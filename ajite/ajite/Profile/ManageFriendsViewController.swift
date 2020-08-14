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
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var manageFriendsTableView: UITableView!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        myUser.friends.removeAll()
        super.viewDidLoad()
        getFriendData()
        manageFriendsTableView.dataSource = self
        manageFriendsTableView.delegate = self
        
        print(myUser.friends.count)
        // Do any additional setup after loading the view.
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    //친구 데이터 가져오기
    func getFriendData(){
        let userRef = db.collection("users")
        //친구인 유저의 documentID 불러오기(state = 2)
        userRef.document(myUser.documentID).collection("friends").whereField("state", isEqualTo: 2 ).getDocuments{(snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else{
                guard let snap = snapshot else {return}
                var count = 0
                for document in snap.documents {
                    //유저 documentID를 통해 users document에 접근해서 해당 유저의 모든 정보를 가져온다.
                    db
                        .collection("users").document(document.documentID).getDocument { (document, error) in
                            if let document = document, document.exists {
                                let data = document.data()
                                //임시로 저장할 유저 변수 생성
                                let temUser = User()
                                //유저 이름 저장
                                temUser.name = data!["name"] as! String
                                //유저 이메일 아이디 저장
                                temUser.userID = data!["userID"] as! String
                                //유저의 프로필 이미지 url 저장
                                temUser.profileImageURL = data!["profileImageURL"] as! String
                                //유저의 documentID 저장
                                temUser.documentID = document.documentID
                                //전체 유저 목록에 추가
                                myUser.friends.append(temUser)
                                //테이블에 불러온 정보를 보여준다.
                                count += 1
                                //모든 친구 요청을 불러왔을 경우,
                                if count == snap.documents.count {
                                    //테이블에 불러온 정보를 보여준다.
                                    self.manageFriendsTableView.reloadData()
                                }
                            } else {
                                print("Document does not exist")
                            }
                    }
                }
            }
        }
    }
    
    // ==================================================================>
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ManageFriendsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.friends.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = manageFriendsTableView.dequeueReusableCell(withIdentifier: "manageFriendsCell", for: indexPath) as! ManageFriendsTableViewCell
        //친구 이름을 Label에 이름 입력
        cell.manageFriendsName.text = myUser.friends[indexPath.row].name
        //프로필 이미지를 url 통해서 UIimage에 입력
        let data = try? Data(contentsOf: URL(string: myUser.friends[indexPath.row].profileImageURL)!)
        cell.manageFriendProfile.image = UIImage(data: data!)
        cell.cellDelegate = self
        //셀에 인덱스 저장
        cell.index = indexPath
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
        return 60
    }
        
    //셀의 순서 바꾸는 기능
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
        
        db.collection("users").document(myUser.documentID).collection("friends").document(myUser.friends[index].documentID).delete()
        let indexPath = IndexPath(item: index, section: 0)
        db.collection("users").document(myUser.friends[index].documentID).collection("friends").document(myUser.documentID).delete()
        myUser.friends.remove(at: index)
        self.manageFriendsTableView.deleteRows(at: [indexPath], with: .automatic)
        //deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    }
}
