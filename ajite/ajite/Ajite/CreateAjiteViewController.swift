//
//  CreateAjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore



class CreateAjiteViewController: UIViewController, FriendsToAjiteDelegate, UITextFieldDelegate {

    // ======================> 변수, outlet 선언
    
    //아지트를 넘겨주기 위해 만든 variable (sort of global within class)
    var tempAjite = Ajite()
    var imageName = String()
    var topFrame = CGRect()//생성되는 아지트에 이미지 집어 넣을때
    var addingMembers = [User]()
    let userRef = db.collection("users")
    
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var ajiteName: UITextField!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidAppear(_ animated: Bool) {
        
        db.collection("users").document(myUser.documentID).collection("invitation").whereField("stateInvite", isEqualTo: 0).getDocuments{(snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                let invitationAlert = UIAlertController(title:"You are invited!!!", message: "Would you like to accept invitation?",preferredStyle: UIAlertController.Style.alert)
                invitationAlert.addAction(UIAlertAction(title:"Yes",style: .default, handler: {(action:UIAlertAction!)in
                        
                        
                }))
                invitationAlert.addAction(UIAlertAction(title:"No",style: .cancel, handler: {
                    (action:UIAlertAction!)
                    in
                }))
            }
        }
    }
    
    //로드가 되었을 때
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let random = arc4random_uniform(4)
        imageName = "\(random)"
        self.memberTableView.dataSource = self
        ajiteName.delegate = self
        
    }
      
    override func viewWillAppear(_ animated: Bool) {
        addingMembers.removeAll()
        memberTableView.reloadData()
        ajiteName.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.layer.removeAllAnimations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InsideAjiteViewController{
        vc.currentAjite = tempAjite
        } else if let vc = segue.destination as? FriendsToAjiteViewController {
            vc.delegate = self
            vc.vcindex = 0
        }
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    //아지트 버튼 "Enter" 누를 때 등장
    @IBAction func pressedEnter(_ sender: Any) {

        //아지트 이름 생성할때 이름 text field 에 아무것도 없으면
        if ajiteName.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            //alert 메세지가 뜬다
            let alert = UIAlertController(title: "Empty Name Field", message: "Your Ajite must have a name.", preferredStyle: .alert)
            //alert 액션이다.
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occured.")}))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        //아지트 Text Field 에 이름이 들어가있다
        else{
            makeNewAjite()
        }
    }
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func makeNewAjite() {
      
        //새로운 아지트 생성함
        
        var ref: DocumentReference? = nil
        ref = db.collection("ajites").addDocument(data: [
            "name": ajiteName.text as Any,
            "ajiteImageString": imageName,
            "memberNum" : 1,
            "songNum" : 0,
        // !!!! "timestamp": ServerValue.timestamp(),
        //!!!!    "creator": myUser
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Ajite added with ID: \(ref!.documentID)")
                self.addMemberToAjite(ajiteID: ref!.documentID)
                let newAjite = Ajite()
                newAjite.name = self.ajiteName.text!
                //newAjite.members = []
                newAjite.sharedSongs.songs = []
                newAjite.ajiteImageString = self.imageName
                newAjite.ajiteID = ref!.documentID
                //currentAjite.append(newAjite)
                //"create" segue 를 이용해 그 세그와 연결된 뷰 컨트롤러로 이동함
                self.tempAjite = newAjite
                self.performSegue(withIdentifier: "create", sender: self)
            }
        }
    }
    
    func addMemberToAjite(ajiteID : String) {
        
        //멤버 숫자
        
        var memberNum = 1
        
        db
            .collection("ajites")
            .document(ajiteID)
            .collection("members").document(myUser.documentID)
            .setData([
                "userID" : myUser.userID as Any,
                "name" : myUser.name as Any
            ])
        
        db
            .collection("users")
            .document(myUser.documentID)
            .collection("ajites").document(ajiteID)
            .setData([
                "name" : self.ajiteName.text as Any,
                "ajiteImageString" : self.imageName
            ])
        //멤버 초대 및 추가
        for addingUser in self.addingMembers{
            self.userRef.document(addingUser.documentID)
                .collection("invitation").document(ajiteID).setData([
                           "ajiteDocumentID" : ajiteID,
                           "ajiteName" : self.ajiteName.text as Any
                           ])
            db.collection("ajites").document(ajiteID).collection("members").document(addingUser.documentID).setData([
                "name":addingUser.name,
                "userID":addingUser.userID,
                
            ])
            
            db.collection("users").document(addingUser.documentID).collection("ajites").document(ajiteID).setData([
                "name" : self.ajiteName.text as Any,
                "ajiteImageString" : self.imageName
            ])
            
            
            memberNum = memberNum + 1
        }
        
        //멤버 숫자 늘이는 코드, 수정필요...
        db.collection("ajites").document(ajiteID).updateData([
            "memberNum" : memberNum
        ])
        
    }
    
    // ==================================================================>
    
    
    func sendUsersBack(sendingMembers: [User]) {
        addingMembers = sendingMembers
        print(addingMembers.count)
        DispatchQueue.main.async {
            self.memberTableView.reloadData()
        }
    }
    
    //아지트 이름은 최대 20자 이상은 못 받게 함
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = ajiteName.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
         let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 20
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ ajiteName: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}


extension CreateAjiteViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addingMembers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "members", for: indexPath) as! MembersToAddTableViewCell
        cell.memberName.text = addingMembers[indexPath.row].name
        let data = try? Data(contentsOf: URL(string: addingMembers[indexPath.row].profileImageURL)!)
        cell.memberImage.image = UIImage(data: data!)
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

