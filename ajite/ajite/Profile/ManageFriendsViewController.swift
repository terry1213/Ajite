//
//  ManageFriendsViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import GoogleSignIn
import FirebaseFirestore

class ManageFriendsViewController: UIViewController, UITableViewDelegate {
    
    let userRef = db.collection("users")
    func getFriendData(){
        print(myUser.documentID)
        userRef.document(myUser.documentID).collection("friends").whereField("state", isEqualTo: 2 ).getDocuments{(snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else{
                print("no error occured")
                print(snapshot!.documents.count as Any)
                guard let snap = snapshot else {return}
                       for document in snap.documents {
                        let data = document.data()
                        let username = data["name"] as? String
                        let userID = data["userID"] as? String
                        let documentID = document.documentID
                        let temUser = User()
                        temUser.name = username!
                        temUser.userID = userID!
                        temUser.documentID = documentID
                        myUser.friends.append(temUser)
                }
            }
            self.manageFriendsTableView.reloadData()
        }
    }
    @IBOutlet weak var manageFriendsTableView: UITableView!
    
    override func viewDidLoad() {
        myUser.friends.removeAll()
        super.viewDidLoad()
        getFriendData()
        manageFriendsTableView.dataSource = self
        manageFriendsTableView.delegate = self
        
        print(myUser.friends.count)
        // Do any additional setup after loading the view.
    }

}
//manageFriendProfile //manageFriendsName
extension ManageFriendsViewController : UITableViewDataSource, FriendUser {
    func onClickCell(index: Int) {
        let deleteAlert = UIAlertController (title: "Unfollow Friend?", message: "You will no longer be able to add your friend to ajites" ,preferredStyle: UIAlertController.Style.alert)
         
         deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
             
            myUser.friends.remove(at: index)
            //self.manageFriendsTableView.deleteRows(at: [IndexPath], with: .automatic)
             
             db.collection("users").document(myUser.documentID).collection("friends").document(myUser.friends[index].documentID).delete()
             
             db.collection("users").document(myUser.friends[index].documentID).collection("friends").document(myUser.documentID).delete()
             
         }))
         
         deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
         self.present(deleteAlert, animated: true, completion: nil)
        
    }
    
    /*
    func deletion(index: Int) {
        // 플레이리스트를 삭제할 때 사용하는 코드
        let deleteAlert = UIAlertController (title: "Unfollow Friend?", message: "You will no longer be able to add your friend to ajites" ,preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
            
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
        
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
            let deleteAlert = UIAlertController (title: "Unfollow Friend?", message: "You will no longer be able to add your friend to ajites" ,preferredStyle: UIAlertController.Style.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
                
                guard editingStyle == .delete else { return }
                myUser.friends.remove(at: indexPath.row)
                self.manageFriendsTableView.deleteRows(at: [indexPath], with: .automatic)
                
                db.collection("users").document(myUser.documentID).collection("friends").document(myUser.friends[indexPath.row].documentID).delete()
                
                db.collection("users").document(myUser.friends[indexPath.row].documentID).collection("friends").document(myUser.documentID).delete()
                
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
           
        }
    }*/
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.friends.count
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = manageFriendsTableView.dequeueReusableCell(withIdentifier: "manageFriendsCell", for: indexPath) as! ManageFriendsTableViewCell
         cell.manageFriendsName.text = myUser.friends[indexPath.row].name
        //cell.manageFriendProfile.image = UIImage(named: playlists[indexPath.row].playlistImageString)
        return cell
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
                return 60
             }
        
        
        func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
            let movedObject = myUser.friends[fromIndexPath.row]
               myUser.friends.remove(at: fromIndexPath.row)
                myUser.friends.insert(movedObject, at: to.row)
            }
        
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the item to be re-orderable.
            return true
        }
}


