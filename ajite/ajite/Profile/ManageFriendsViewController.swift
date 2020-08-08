//
//  ManageFriendsViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class ManageFriendsViewController: UIViewController {

    @IBOutlet weak var manageFriendsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageFriendsTableView.dataSource = self
       
        // Do any additional setup after loading the view.
    }

}
//manageFriendProfile //manageFriendsName
extension ManageFriendsViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
               return 1
           }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myUser.friends.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = manageFriendsTableView.dequeueReusableCell(withIdentifier: "manageFriendsCell", for: indexPath) as! ManageFriendsTableViewCell
             cell.manageFriendsName.text = myUser.friends[indexPath.row].name
                    
//!!!!!!!!!!!!!!!!!!!!!!!! 여기 수정 해주세요 !!!!!!!!!!!!!!!!!!!!!
                    
                    cell.manageFriendProfile.image = UIImage(named: playlists[indexPath.row].playlistImageString)
                    return cell
                }
        
        func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
                return 60
             }
        
        
    // 플레이리스트를 삭제할 때 사용하는 코드
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
            let deleteAlert = UIAlertController (title: "Unfollow Friend?", message: "You will no longer be able to add your friend to ajites" ,preferredStyle: UIAlertController.Style.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
                
                guard editingStyle == .delete else { return }
                myUser.friends.remove(at: indexPath.row)
                self.manageFriendsTableView.deleteRows(at: [indexPath], with: .automatic)
                
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
           
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


