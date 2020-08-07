//
//  AjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//


import UIKit
import GoogleSignIn

var ajite :[Ajite] = []

class AjiteViewController: UIViewController{
    
    
    @IBOutlet weak var ajiteTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.ajiteImage.image = UIImage(named: ajite[indexPath.row].ajiteImageString)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt
     indexPath: IndexPath) -> CGFloat {
             return 90
          }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         
          let deleteAlert = UIAlertController (title: "Leave Ajite", message: "Would you like to leave this Ajite?" ,preferredStyle: UIAlertController.Style.alert)
          
          deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
              guard editingStyle == .delete else { return }
              ajite.remove(at: indexPath.row)
              self.ajiteTable.deleteRows(at: [indexPath], with: .automatic)
              
          }))
          deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
          self.present(deleteAlert, animated: true, completion: nil)
         
      }
      
      func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
          let movedObject = ajite[fromIndexPath.row]
             ajite.remove(at: fromIndexPath.row)
              ajite.insert(movedObject, at: to.row)
          }
}

extension AjiteViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dataToSend = ajite[indexPath.row]
    self.performSegue(withIdentifier: "intoAjite", sender: dataToSend)
    }
}
