//
//  ChatViewController.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/6/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblvw: UITableView!
    static var sender = 0
    var contactNumber : NSMutableArray!
    var last = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactNumber = ModelManager.getInstance().getAllData("user")
        tblvw.register(UINib(nibName : "ChatListCell",bundle : nil), forCellReuseIdentifier: "ChatListCell")
        tblvw.delegate = self
        tblvw.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
        let all = ModelManager.getInstance().getAllData("user")
        let c = all.count
        for i in 0..<c {
            let contact = contactNumber.object(at: i) as AnyObject
            let latest = ModelManager.getInstance().getlatest("chat" , "\(AppDelegate.senderId)" , "\(contact.value(forKey: "user_id") as! Int)")
            if latest.count > 0 {
                let obj = latest.lastObject as AnyObject
                last.append(obj.value(forKey: "message") as! String)
            }
        }
//        for i in contact {
//            let ob = i as AnyObject
//            if ob.value(forKey: "sender_id") as! String == senderId {
//                let message = JSQMessage(senderId: ob.value(forKey: "sender_id") as! String, displayName: "Master" , text: ob.value(forKey: "message") as! String)
//                messages.append(message!)
//            } else {
//                let message = JSQMessage(senderId: ob.value(forKey: "sender_id") as! String, displayName: "name" , text: ob.value(forKey: "message") as! String)
//                messages.append(message!)
//            }
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func loadList(){
        self.tblvw.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactNumber.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        let contact = contactNumber.object(at: indexPath.row) as AnyObject
        cell.contactNm.text = String(describing: contact.value(forKey: "user_id") as! Int)
        if (!last.isEmpty && contact.value(forKey : "user_id") as? Int == ChatViewController.sender) {
            cell.lstmsg.text = last[0]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contactNumber.object(at: indexPath.row) as AnyObject
        MessageViewController.reciever_id = contact.value(forKey: "user_id") as! Int
        self.navigationController?.pushViewController(MessageViewController(), animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   
    
}
