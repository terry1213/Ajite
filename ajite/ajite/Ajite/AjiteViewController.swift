//
//  AjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//


import UIKit
import GoogleSignIn
import Firebase

var ajites :[Ajite] = []

class AjiteViewController: UIViewController{
    
    
    @IBOutlet weak var ajiteTable: UITableView!
    let db = Firestore.firestore()
    
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
        self.getData()
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
    
    func getData(){
        db.collection("ajites").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                ajites.removeAll()
                var temAjite: Ajite
                for document in querySnapshot!.documents {
                    temAjite = Ajite()
                    temAjite.name = document.data()["name"] as! String
                    //newAjite.numberOfMembers = document.data()["name"]
                    //newAjite.members = []
                    //temAjite.sharedSongs = document.data()["sharedSongs"] as! [String]
                    temAjite.ajiteImageString = document.data()["ajiteImageString"] as! String
                    temAjite.ajiteID = document.documentID
                    ajites.append(temAjite)
                }
                print("The number of ajite is \(ajites.count)")
                DispatchQueue.main.async{
                    self.ajiteTable.reloadData()
                }
            }
        }
    }
}

extension AjiteViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
             return 1
         }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ajites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ajiteTable.dequeueReusableCell(withIdentifier: "AjiteCell", for: indexPath) as! AjiteTableViewCell
        cell.ajiteName.text = ajites[indexPath.row].name
        cell.numberOfMembers.text = "\(ajites[indexPath.row].members.count) members"
        cell.ajiteImage.image = UIImage(named: ajites[indexPath.row].ajiteImageString)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt
     indexPath: IndexPath) -> CGFloat {
             return 90
          }
}

extension AjiteViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dataToSend = ajites[indexPath.row]
    self.performSegue(withIdentifier: "intoAjite", sender: dataToSend)
    }
}
