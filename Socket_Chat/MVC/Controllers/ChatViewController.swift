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
    var msgCount: [Int]! = []

    
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
    
    func countmsg() {
        contactNumber = ModelManager.getInstance().getAllData("user")
        msgCount.removeAll()
        for i in contactNumber {
            let a = i as AnyObject
            let count = ModelManager.getInstance().getCount("chat", "sender_id = \(a.value(forKey: "user_id") as! Int) AND status = \'false\'", "status")
            msgCount.append(Int(count["COUNT(status)"] as! String)!)
        }
        contactNumber = zip(contactNumber, msgCount).sorted(by: { (a, b) -> Bool in
            return a.1 > b.1
        }) as! NSMutableArray
//        tblvw.reloadData()
        //        print(contactNumber)
    }
    
    func loadList(){
        countmsg()
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
        let contact = contactNumber.object(at: indexPath.row) as! (Any,Any)
        cell.contactNm.text = String(describing: (contact.0 as AnyObject).value(forKey: "user_id") as! Int)
        let latest = ModelManager.getInstance().getlatest("chat" , "\(AppDelegate.senderId)" , "\((contact.0 as AnyObject).value(forKey: "user_id") as! Int)")
        var lastMsg: String!
        var obj: AnyObject!
        if latest.count > 0 {
             obj = latest.lastObject as AnyObject
            lastMsg = obj.value(forKey: "message") as! String
        }
        if obj != nil && (!last.isEmpty && (contact.0 as AnyObject).value(forKey : "user_id") as? Int == Int(obj.value(forKey: "sender_id") as! String) || !last.isEmpty && (contact.0 as AnyObject).value(forKey : "user_id") as? Int == Int(obj.value(forKey: "receiver_id") as! String)) {
            cell.lstmsg.text = lastMsg
        }
        cell.msgcount.text = String(describing: contact.1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contactNumber.object(at: indexPath.row) as! (Any,Any)
        MessageViewController.reciever_id = ((contact.0) as AnyObject).value(forKey: "user_id") as! Int
        self.navigationController?.pushViewController(MessageViewController(), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   
    
}
