//
//  AjiteListViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/04.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

var ajites : [Ajite] = []

class AjiteListViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var ajiteList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ajiteList.dataSource = self
        self.ajiteList.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAjitesID() {
            self.getAjitesData() {
                self.ajiteList.reloadData()
            }
            
        }
        ajiteList.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue")
        guard segue.identifier == "intoAjite" else {
            return
        }
        guard let sendingAjite = sender as? Ajite else {
            return
        }
        guard let destination = segue.destination as? InsideAjiteViewController else{
            return
        }
        destination.currentAjite = sendingAjite
    }
    
    // 아지트 아이디를 가져오는 함수
    func getAjitesID(completion: @escaping () -> Void){
        db
            .collection("users")
            .document(myUser.documentID)
            .collection("ajites")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    ajites.removeAll()
                    var temAjite: Ajite
                    for document in querySnapshot!.documents {
                        temAjite = Ajite()
                        temAjite.ajiteID = document.documentID
                        ajites.append(temAjite)
                    }
                    print("The number of ajite is \(ajites.count)")
                    completion()
                }
            }
    }
    
    // 아지트 데이터를 가져오는 함수
    func getAjitesData(completion: @escaping () -> Void) {
        for i in 0..<ajites.count {
            db
                .collection("ajites")
                .document(ajites[i].ajiteID)
                .getDocument { (document, error) in
                    if let document = document, document.exists {
                        ajites[i].name = document.data()!["name"] as! String
                        ajites[i].ajiteImageString = document.data()!["ajiteImageString"] as! String
                        ajites[i].numOfMembers = document.data()!["memberNum"] as! Int
                        ajites[i].numOfSongs = document.data()!["songNum"] as! Int
                    } else {
                        print("Document does not exist")
                    }
                    completion()
                }
        }
    }
    
    // 아지트를 유저의 아지트 목록에서 삭제하는 함수
    func deleteAjiteFromUser(ajiteIDToDelete: String, completion: @escaping () -> Void) {
        db
            .collection("users").document(myUser.documentID)
            .collection("ajites").document(ajiteIDToDelete)
            .delete()
        completion()
    }
    
    // 유저를 아지트 맴버에서 삭제하는 함수
    func deleteUserFromAjite(ajiteIDToDelete: String, completion: @escaping () -> Void) {
        db
            .collection("ajites").document(ajiteIDToDelete)
            .collection("members").document(myUser.documentID)
            .delete()
        completion()
    }
    
    // 아지트 맴버 수를 줄이는 함수
    func reduceMemberNum(ajiteIDToDelete: String, completion: @escaping () -> Void) {
        db
            .collection("ajites").document(ajiteIDToDelete)
            .updateData([
                "memberNum" : FieldValue.increment(Int64(-1))
            ])
        completion()
    }
    
    // 아지트를 삭제하는 함수
    func deleteAjite(ajiteIDToDelete: String, completion: @escaping () -> Void) {
        db
            .collection("ajites").document(ajiteIDToDelete)
            .delete()
        completion()
    }
    
    // 아지트 맴버가 더 이상 없는지 확인하고 아지트 자체를 삭제하는 함수
    func checkAjite(ajiteIDToDelete: String, indexPath: IndexPath, completion: @escaping () -> Void) {
        db
            .collection("ajites").document(ajiteIDToDelete)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    self.reduceMemberNum(ajiteIDToDelete: ajiteIDToDelete) {
                        if document.data()!["memberNum"] as! Int == 1 {
                            self.deleteAjite(ajiteIDToDelete: ajiteIDToDelete) {
                                completion()
                            }
                        }
                    }
                    
                    ajites.remove(at: indexPath.row)
                    self.ajiteList.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    print("Document does not exist")
                }
            }
    }
    
    @IBAction func order(_ sender: Any) {
        print("Order Button pressed")
    }
    
}

extension AjiteListViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ajites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ajiteList.dequeueReusableCell(withIdentifier: "AjiteCell", for: indexPath) as! AjiteTableViewCell
        cell.ajiteName.text = ajites[indexPath.row].name
        cell.ajiteImage.image = UIImage(named: "ajitelogo.png")
        cell.numberOfMembers.text = "\(ajites[indexPath.row].numOfMembers)"
        cell.numberOfSongs.text = "\(ajites[indexPath.row].numOfSongs)"
        
        
        // add shadow on cell
        cell.backgroundColor = .clear// very important
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.23
        cell.layer.shadowRadius = 15
        cell.layer.cornerRadius = 15
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowColor = UIColor.black.cgColor
        
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //table view 에 있는 cell 을 삭제 할 때
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let deleteAlert = UIAlertController (title: "Leave Ajite", message: "Would you like to leave this Ajite?" ,preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
            guard editingStyle == .delete else { return }
            
            let ajiteIDToDelete = ajites[indexPath.row].ajiteID
            
            self.deleteAjiteFromUser(ajiteIDToDelete: ajiteIDToDelete) {
                self.deleteUserFromAjite(ajiteIDToDelete: ajiteIDToDelete) {
                    self.checkAjite(ajiteIDToDelete: ajiteIDToDelete, indexPath: indexPath){
                        
                    }
                }
            }
            
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = ajites[fromIndexPath.row]
        ajites.remove(at: fromIndexPath.row)
        ajites.insert(movedObject, at: to.row)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
}

extension AjiteListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let dataToSend = ajites[indexPath.row]
                self.performSegue(withIdentifier: "intoAjite", sender: dataToSend)
    }
}
