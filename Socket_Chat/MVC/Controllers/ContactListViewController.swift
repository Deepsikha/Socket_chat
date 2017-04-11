//
//  ContactListViewController.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/7/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblvw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        tblvw.delegate = self
        tblvw.dataSource = self
        tblvw.register(UINib(nibName : "ContactViewCell" , bundle : nil), forCellReuseIdentifier: "ContactViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvw.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as! ContactViewCell
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
