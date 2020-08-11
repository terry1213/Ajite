//
//  ManageFriendsViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import GoogleSignIn
import FirebaseFirestore

class ManageFriendsViewController: UIViewController{
    
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
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //keyboard 아무 곳이나 터치하면 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
}
//manageFriendProfile //manageFriendsName
extension ManageFriendsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.friends.count
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = manageFriendsTableView.dequeueReusableCell(withIdentifier: "manageFriendsCell", for: indexPath) as! ManageFriendsTableViewCell
         cell.manageFriendsName.text = myUser.friends[indexPath.row].name
        //cell.manageFriendProfile.image = UIImage(named: playlists[indexPath.row].playlistImageString)
        cell.cellDelegate = self
        cell.index = indexPath
        cell.cellDelegate = self
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
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

extension ManageFriendsViewController: FriendUser{
    func onClickCell(index: Int) {
            let deleteAlert = UIAlertController (title: "Unfollow Friend?", message: "You will no longer be able to add your friend to ajites" ,preferredStyle: UIAlertController.Style.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
                
               
                
                db.collection("users").document(myUser.documentID).collection("friends").document(myUser.friends[index].documentID).delete()
                
                db.collection("users").document(myUser.friends[index].documentID).collection("friends").document(myUser.documentID).delete()
                myUser.friends.remove(at: index)

                let indexPath = IndexPath(item: index, section: 0)
                self.manageFriendsTableView.deleteRows(at: [indexPath], with: .automatic)
              
        }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            present(deleteAlert, animated: true, completion: nil)
        
    }
    
    
}

extension ManageFriendsViewController: ManageFriendViewCellDelegate {
    func deletion(_ ManageFriendsTableViewCell: ManageFriendsTableViewCell, index: Int) {
        
        print("clicked")
    
        db.collection("users").document(myUser.documentID).collection("friends").document(myUser.friends[index].documentID).delete()
        let indexPath = IndexPath(item: index, section: 0)
        db.collection("users").document(myUser.friends[index].documentID).collection("friends").document(myUser.documentID).delete()
        myUser.friends.remove(at: index)
        self.manageFriendsTableView.deleteRows(at: [indexPath], with: .automatic)

    
    //deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    }
}
