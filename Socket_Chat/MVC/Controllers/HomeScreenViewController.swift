//
//  HomeScreenViewController.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/7/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import SocketRocket

class HomeScreenViewController: UIViewController, SlidingContainerViewControllerDelegate , SRWebSocketDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendInitMsg()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    func sendInitMsg(){
        do {
            var dic:[String:Any]!
            dic = ["senderId":123456789,"type":"initConnection"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            Constants.websocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: SlidingContainerViewControllerDelegate
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {
        
    }
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print(dic!)
        do {
            var dic1:[String:Any]!
            var jsonData: Data!
            switch dic1!["type"] as! String {
                case "error":
                
                break
                case "authErr":
                
                break
                case "connected":
                break
                case "history":
                
                break
                case "msgAck":
                
                break
                case "message":
                
                
                break
                case "readMsgAck":
                
                break
                default: break
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
