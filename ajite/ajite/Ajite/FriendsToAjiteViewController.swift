//
//  FriendsToAjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class FriendsToAjiteViewController: UIViewController {


    var addingMembers = [User]()
    var addedMembers = [User]()
    
    
    @IBOutlet weak var searchFriendsTable: UITableView!
    @IBOutlet weak var addedMembersTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addedMembersTable.dataSource = self
        self.addedMembersTable.delegate = self
        self.searchFriendsTable.dataSource = self
    }
}


extension FriendsToAjiteViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
               return 1
           }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == self.addedMembersTable{
            return addedMembers.count
            } else {return addingMembers.count}
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 60
         }
    
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == self.addedMembersTable{
            let cell = addedMembersTable.dequeueReusableCell(withIdentifier: "addedMembers", for: indexPath) as! AddedFriendsTableViewCell
            cell.addedMembersLabel.text = addedMembers[indexPath.row].name
            //!!!!!!!!!!!구현하기 유저 이미지 불러오기 !!!!!!!  cell.addedFriendsProfile.image = UIImage(named: addedMembers[indexPath.row].)
       
            }
            else if tableView == self.searchFriendsTable{
                let cell = searchFriendsTable.dequeueReusableCell(withIdentifier: "searchFriends", for: indexPath) as! searchFriendsTableViewCell
                cell.searchFriendName.text = addingMembers[indexPath.row].name
                //     cell.searchUser = myUser.friendds 에 저장
                 //!!!!!!!!!!!구현하기 유저 이미지 불러오기 !!!!!!!      cell.playlistImage.image = UIImage(named: playlists[indexPath.row].playlistImageString)
                return cell
            }
            return UITableViewCell()
    }
        
        
    // 플레이리스트를 삭제할 때 사용하는 코드
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
            if tableView == self.addedMembersTable{
                
                guard editingStyle == .delete else { return }
               addedMembers.remove(at: indexPath.row)
                
                self.addedMembersTable.deleteRows(at: [indexPath], with: .automatic)
                
            }
           
           
    }
        
        func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
            let movedObject = addedMembers[fromIndexPath.row]
               addedMembers.remove(at: fromIndexPath.row)
               addedMembers.insert(movedObject, at: to.row)
            }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchFriendsTable{
            //여기에 먼저 해당 아지트의 멤버를 뒤진다
            //해당 아지트에 멤버가 없으면 addingMembers에 append한다 
        }
        
        }
}


extension FriendsToAjiteViewController: UITableViewDelegate {
  /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dataToSend = playlists[indexPath.row]
    self.performSegue(withIdentifier: "toPlaylist", sender: dataToSend)*/
    //위 코드는 segue를 통해 데이터를 다른 뷰 컨트롤러로 보내는건데 우리의 경우에는 createAjiteViewController이면 생성될 아지트의 멤버 옵젝트와 연결하는게 맞고 segue가 이미 생성된 아지트 내에 추가적으로 애드 할 거면 이제 그 생성될 아지트 내에 멤버 오브젝트에 추가하는게 맞고 ㅇㅇ
   // }
}

