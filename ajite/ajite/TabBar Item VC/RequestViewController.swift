//
//  RequestViewController.swift
//  
//
//  Created by Chanwoong Ahn on 2020/08/09.
//

import Foundation
import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import GoogleSignIn
import FirebaseFirestore

class RequestViewController: UIViewController{
    
    // ======================> 변수, outlet 선언
    
    //나에게 친구 신청을 보낸 사람들 목록
    var requestUsers : [User] = []
    
    @IBOutlet var RequestTV: UITableView!
    
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RequestTV.delegate = self
        self.RequestTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //유저의 정보를 가져온다.
        getFriendRequest(){
            self.RequestTV.reloadData()
        }
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func getFriendRequest(completion: @escaping () -> Void){
        //친구 목록중에 나에게 친구 신청을 보낸(state = 1) 유저의 documentID를 불러온다.
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").whereField("state", isEqualTo: 1).addSnapshotListener{ (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                }
                self.requestUsers.removeAll()
                guard let snap = snapshot else {return}
                var count = 0
                if snap.documents.count == 0 {
                    completion()
                }
                for document in snap.documents {
                    //유저 documentID를 통해 users document에 접근해서 해당 유저의 모든 정보를 가져온다.
                    self.getUserData(userDocumentID: document.documentID){
                        count += 1
                        //모든 친구 요청을 불러왔을 경우,
                        if count == snap.documents.count {
                            completion()
                        }
                    }
                }
        }
    }
    
    //유저 documentID를 통해 해당 유저의 정보를 가져오는 함수.
    func getUserData(userDocumentID : String, completion: @escaping () -> Void){
        db.collection("users").document(userDocumentID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                //임시로 저장할 유저 변수 생성
                let temUser = User()
                //유저 이름 저장
                temUser.name = data!["name"] as! String
                //유저 이메일 아이디 저장
                temUser.userID = data!["userID"] as! String
                //유저의 프로필 이미지 url 저장
                temUser.profileImageURL  = data!["profileImageURL"] as! String
                //유저의 documentID 저장
                temUser.documentID = document.documentID
                //친구 신청 목록에 추가
                self.requestUsers.append(temUser)
                completion()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func changeRequest(userFrom : User, userTo : User, state: Int){
        db.collection("users").document(userTo.documentID).collection("friends").document(userFrom.documentID).updateData([
            "userID" : userFrom.userID as Any,
            "name" : userFrom.name as Any,
            /*
             친구 state 설명:
             0 = 친구 신청 보냄
             1 = 친구 신청 받음
             2 = 친구 상태
             거절하면 document 자체를 삭제
             */
            "state" : state
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func deleteRequest(userFrom : User, userTo : User){
        db
            .collection("users").document(userTo.documentID)
            .collection("friends").document(userFrom.documentID).delete() { err in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleted")
                }
        }
    }
    // ==================================================================>
    
}

extension RequestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requestUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestTableViewCell
        //유저 이름을 Label에 이름 입력
        cell.nameBox?.text = requestUsers[indexPath.row].name
        //프로필 이미지를 url 통해서 UIimage에 입력
        let data = try? Data(contentsOf: URL(string: requestUsers[indexPath.row].profileImageURL)!)
        cell.profileImage.image = UIImage(data: data!)
        cell.cellDelegate = self
        //셀의 인덱스 저장
        cell.index = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension RequestViewController: RequestTableViewUser {
    func AcceptClickCell(index: Int) {
        //친구 신청을 보낸 유저의 친구 목록에서 document를 찾아 상태를 친구로 변경한다.(state -> 2)
        self.changeRequest(userFrom: myUser, userTo: requestUsers[index], state: 2)
        
        //친구 신청을 받은 유저의 친구 목록에서 document를 찾아 상태를 친구로 변경한다.(state -> 2)
        self.changeRequest(userFrom: requestUsers[index], userTo: myUser, state: 2)
    }
    
    func DeclineClickCell(index: Int) {
        //친구 신청을 보낸 유저의 친구 document를 찾아 삭제한다.
        deleteRequest(userFrom: requestUsers[index], userTo: myUser)
        
        //친구 신청을 받은 유저의 친구 document를 찾아 삭제한다.
        deleteRequest(userFrom: myUser, userTo: requestUsers[index])
    }
}
