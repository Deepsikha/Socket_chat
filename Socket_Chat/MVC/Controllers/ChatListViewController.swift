//
//  ChatListViewController.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/7/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tblvw: UITableView!
    var chats = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        tblvw.delegate = self
        tblvw.dataSource = self
        tblvw.register(UINib(nibName : "ChatListCell",bundle : nil), forCellReuseIdentifier: "ChatListCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvw.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        cell.imgvw.image = UIImage(named : "")
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
}
