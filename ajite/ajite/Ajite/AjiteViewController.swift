//
//  AjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//


import UIKit

var ajite :[Ajite] = []

class AjiteViewController: UIViewController{
    
    
    @IBOutlet weak var ajiteTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ajiteTable.layer.cornerRadius = 20.0
        self.ajiteTable.dataSource = self
        self.ajiteTable.delegate = self
        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ajiteTable.reloadData()
    }
    
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard segue.identifier == "intoAjite" else {
               return
           }
           guard let sendingAjite = sender as? Ajite else {
               return
           }
           guard let destination = segue.destination as? AjiteRoomViewController else{
               return
           }
           destination.currentAjite = sendingAjite
       }
}

extension AjiteViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
             return 1
         }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ajite.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ajiteTable.dequeueReusableCell(withIdentifier: "AjiteCell", for: indexPath) as! AjiteTableViewCell
        cell.ajiteName.text = ajite[indexPath.row].name
        cell.numberOfMembers.text = "\(ajite[indexPath.row].numberOfMembers) members"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt
     indexPath: IndexPath) -> CGFloat {
             return 90
          }
}

extension AjiteViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dataToSend = ajite[indexPath.row]
    self.performSegue(withIdentifier: "intoAjite", sender: dataToSend)
    }
}