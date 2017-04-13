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
    
    var contactNumber : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactNumber = ModelManager.getInstance().getAllData("user")
        tblvw.register(UINib(nibName : "UserViewCell",bundle : nil), forCellReuseIdentifier: "UserViewCell")
        tblvw.delegate = self
        tblvw.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
        
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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        let contact = contactNumber.object(at: indexPath.row) as AnyObject
        cell.cntctnm.text = String(describing: contact.value(forKey: "user_id") as! Int)
        return cell
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
