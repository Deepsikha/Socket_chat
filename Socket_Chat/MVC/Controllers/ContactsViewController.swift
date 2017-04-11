//
//  ContactsViewController.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/11/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tblvw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblvw.register(UINib(nibName : "UserViewCell", bundle : nil), forCellReuseIdentifier: "UserViewCell")
            }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvw.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
