//
//  ChatViewController.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/6/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SocketRocket

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,SRWebSocketDelegate {
    
    @IBOutlet var tblvw: UITableView!
    
    var websocket: SRWebSocket!
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect()
        tblvw.register(UINib(nibName : "UserViewCell",bundle : nil), forCellReuseIdentifier: "UserViewCell")
        tblvw.delegate = self
        tblvw.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MessageViewController(), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        websocket.close()
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("Connected")
        do {
            var dic:[String:Any]!
            dic = ["senderId":987654321,"type":"initConnection"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            webSocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func connect(){
        websocket = SRWebSocket(url: URL(string: "https://opvenjtjqo.localtunnel.me"))
            websocket.delegate = self
            websocket.open()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("Code: \(code)\nReason: \(reason)")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let dic = convertToDictionary(text: message as! String)
        print(dic!)
        if let rep = dic!["msgAck"] {
            do {
                var dic:[String:Any]!
                dic = ["senderId":987654321,"type":"readMsgAck","receiverId":123456789]
                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                websocket.send(NSData(data: jsonData))
            } catch {
                print(error.localizedDescription)
            
            }
        }//        if (dic!["reply"] as! String) == "unauthorized User!" {
        //            let vc = RegisterViewController()
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        do {
            var dic:[String:Any]!
            dic = ["senderId":987654321,"message":"hello","recieverId":123456789,"type":"message"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            websocket.send(NSData(data: jsonData))
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
