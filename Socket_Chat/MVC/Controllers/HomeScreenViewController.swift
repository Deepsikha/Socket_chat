import UIKit
import SocketRocket
import JSQMessagesViewController
import UserNotifications

class HomeScreenViewController: UIViewController, SlidingContainerViewControllerDelegate,SRWebSocketDelegate {
    var isGrantedNotificationAccess:Bool = false
    static var messages = [JSQMessage]()
    
    
    
    override func viewDidLoad() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge], completionHandler: {
            (granted,error) in
            self.isGrantedNotificationAccess = granted
        })
        super.viewDidLoad()
        connect()
    }
    
    func sendInitMsg(){
        do {
            var dic:[String:Any]!
            
            dic = ["senderId":9610555504,"type":"initConnection"]
            
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            AppDelegate.websocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendnotification(_ senderId : String , _ message : String) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "\(senderId)", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "\(message)", arguments: nil)
        content.sound = UNNotificationSound.default()
//        content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber;
        //content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1.0,
            repeats: false)
        AppDelegate.app.applicationIconBadgeNumber = AppDelegate.app.applicationIconBadgeNumber + 1
        
        let request = UNNotificationRequest.init(identifier: "testTriggerNotif", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.websocket.delegate = self
        let slidingContainerViewController = SlidingContainerViewController (
            parent: self,
            contentViewControllers: [ChatViewController(), UserProfileViewController(), ContactsViewController()],
            titles: ["Chat", "User", "Contact"])
        
        view.addSubview(slidingContainerViewController.view)
        view.addSubview(slidingContainerViewController.view)
        
        slidingContainerViewController.sliderView.appearance.outerPadding = 0
        slidingContainerViewController.sliderView.appearance.innerPadding = 50
        slidingContainerViewController.sliderView.appearance.fixedWidth = true
        slidingContainerViewController.setCurrentViewControllerAtIndex(0)
        slidingContainerViewController.delegate = self
    }
    
    func viewControllerWithColorAndTitle (_ color: UIColor, title: String) -> UIViewController {
        let vc = UIViewController ()
        vc.view.backgroundColor = color
        
        let label = UILabel (frame: vc.view.frame)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont (name: "HelveticaNeue-Light", size: 25)
        label.text = title
        
        label.sizeToFit()
        label.center = view.center
        
        vc.view.addSubview(label)
        
        return vc
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("Connected")
        if(AppDelegate.websocket.readyState == SRReadyState.OPEN) {
        sendInitMsg()
        }
    }
    
    func connect(){
        AppDelegate.websocket = SRWebSocket(url: URL(string: "https://gvmmlfwgza.localtunnel.me"))
        AppDelegate.websocket.delegate = self
        AppDelegate.websocket.open()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("closed")
    }
    
    // MARK: SlidingContainerViewControllerDelegate
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {
        
    }
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: SRWebSocketDelegate methods
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let dic = convertToDictionary(text: message as! String)
        print(dic!)
        do {
            var count:[String:Any]!
            var jsonData: Data!
            switch dic!["type"] as! String {
            case "error":
                
                break
            case "authErr":
                
                break
            case "connected":
                let a = ModelManager.getInstance().senddataserver("chat")
                for i in a {
                    let ob = i as AnyObject
                        var dic:[String:Any]!
                        dic = ["senderId": ob.value(forKey: "sender_id")! as! Int,"message": ob.value(forKey: "message")! as! String,"recieverId": ob.value(forKey: "receiver_id")! as! Int,"type":"message"]
                        let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                        if(AppDelegate.websocket.readyState != SRReadyState.CLOSED) {
                            AppDelegate.websocket.send(NSData(data:jsonData))
                            
                            ModelManager.getInstance().updateData("chat", "ack = 1", "ack = 0 and rowid = \(String(describing: ob.value(forKey: "id")!))")
                        }
                }
                
                break
            case "msgAck":
                
                break
            case "message":
                for i in dic!["data"] as! NSArray {
                    let a = i as AnyObject
                    _ = ModelManager.getInstance().addData("chat", "sender_id,receiver_id,message,time,status", "\(String(describing: a.value(forKey: "sender_id") as! Int)),\(AppDelegate.senderId),\'\(String(describing: a.value(forKey: "message")!))\',\'\(String(describing: a.value(forKey: "time")!))\',\'false\'")
                    ChatViewController.sender = (a.value(forKey: "sender_id") as! Int)
                    sendnotification((String(describing: a.value(forKey: "sender_id") as! Int)),(String(describing: a.value(forKey: "message")!)))
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                break
            case "readMsgAck":
                
                break
            default: break
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
}
