//
//  MemberTableViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/06.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    var memberViewAjite = Ajite()
    @IBOutlet weak var memberTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memberTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.memberTableView.reloadData()
       }
    
     
}


extension MemberViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return memberViewAjite.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! memberInAjiteTableViewCell
       
        cell.memberName.text =  memberViewAjite.members[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
       indexPath: IndexPath) -> CGFloat {
               return 60
            }
}
