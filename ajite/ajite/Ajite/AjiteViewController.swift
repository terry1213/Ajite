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
import FirebaseFirestore

var ajites :[Ajite] = []

class AjiteViewController: UIViewController{
    
    @IBOutlet weak var ajiteTable: UITableView!
    let db = Firestore.firestore()
    
    
 // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ajiteTable.dataSource = self
        self.ajiteTable.delegate = self
        // Do any additional setup after loading the view.
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

    // ==================================================================>
    
    
    //데이터베이스에서 데이터를 불러내는 함수
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
        cell.ajiteImage.image = UIImage(named: ajites[indexPath.row].ajiteImageString)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt
     indexPath: IndexPath) -> CGFloat {
             return 90
          }
    
//table view 에 있는 cell 을 삭제 할 때
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         
          let deleteAlert = UIAlertController (title: "Leave Ajite", message: "Would you like to leave this Ajite?" ,preferredStyle: UIAlertController.Style.alert)
          
          deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
              guard editingStyle == .delete else { return }
              ajites.remove(at: indexPath.row)
              self.ajiteTable.deleteRows(at: [indexPath], with: .automatic)
              
          }))
          deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
          self.present(deleteAlert, animated: true, completion: nil)
         
      }
      
      func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
          let movedObject = ajites[fromIndexPath.row]
             ajites.remove(at: fromIndexPath.row)
              ajites.insert(movedObject, at: to.row)
          }
}

extension AjiteViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dataToSend = ajites[indexPath.row]
    self.performSegue(withIdentifier: "intoAjite", sender: dataToSend)
    }
}
