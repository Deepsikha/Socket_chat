import UIKit
import SocketRocket

class HomeScreenViewController: UIViewController, SlidingContainerViewControllerDelegate,SRWebSocketDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect()
    }
    
    func sendInitMsg(){
        do {
            var dic:[String:Any]!
            dic = ["senderId":123456789,"type":"initConnection"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            AppDelegate.websocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
        }
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
        sendInitMsg()
        
    }
    
    func connect(){
        AppDelegate.websocket = SRWebSocket(url: URL(string: "https://hvympnylwa.localtunnel.me"))
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
            var dic1:[String:Any]!
            var jsonData: Data!
            switch dic!["type"] as! String {
            case "error":
                
                break
            case "authErr":
                
                break
            case "connected":
                break
            case "msgAck":
                
                break
            case "message":
//                let message = JSQMessage(senderId: String(describing: dic!["author"]), senderDisplayName: "Kt", date: Date(), text: dic!["text"] as! String)
//                self.messages.append(message!)
//                ModelManager.getInstance().addData("chat", "sender_id,receiver_id,message,time", "\(String(describing: dic!["author"]!)),\(senderId!),\'\(String(describing: dic!["text"]!))\',\'\(String(describing: dic!["time"]!))\'")
//                collectionView.reloadData()
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
