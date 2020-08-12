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

    //아지트를 넘겨주기 위해 만든 variable (sort of global within class)
    var tempAjite = Ajite()
    var imageName = String()
    var topFrame = CGRect()//생성되는 아지트에 이미지 집어 넣을때
    var addingMembers = [User]()
    let userRef = db.collection("users")
    //FriendstoAjite Controller 에서 adding Member
//==========================애니메이션==========================
    
    
  //Outlet들
 
  
 
  
    @IBOutlet weak var backgroundImage0: UIImageView!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var ajiteName: UITextField!
    
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
        print(addingMembers.first?.name)
        self.backgroundImage0.transform = .identity
        animateView()
        ajiteName.text = ""
        
        
}
   
    func animateView(){
        UIView.animate(withDuration: 20.0, delay: 0.0, options:[ .curveLinear, .repeat] , animations: {
                      self.topFrame = self.backgroundImage0.frame

            self.topFrame.origin.y -= self.topFrame.size.height/1.3
                            
                              
                      self.backgroundImage0.frame = self.topFrame
                            
        }, completion: { finished in
            self.backgroundImage0.frame.origin.y += self.topFrame.size.height/1.3        })
    }
  
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.layer.removeAllAnimations()
    }

    
    func sendUsersBack(sendingMembers: [User]) {
        addingMembers = sendingMembers
        print(addingMembers.count)
      //  print(addingMembers.first?.name)
        DispatchQueue.main.async {
            self.memberTableView.reloadData()
        }
    }
    
    
    
    
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
            //새로운 아지트 생성함
            var ref: DocumentReference? = nil
            ref = db.collection("ajites").addDocument(data: [
                "name": ajiteName.text as Any,
                "ajiteImageString": imageName,
                "memberNum" : 1
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Ajite added with ID: \(ref!.documentID)")
                    
                    //현재 아지트 아이디
                    
                    db
                        .collection("ajites")
                        .document(ref!.documentID)
                        .collection("members").document(myUser.documentID)
                        .setData([
                            "userID" : myUser.userID as Any,
                            "name" : myUser.name as Any
                        ])
                    
                    db
                        .collection("users")
                        .document(myUser.documentID)
                        .collection("ajites").document(ref!.documentID)
                        .setData([
                            "name" : self.ajiteName.text as Any,
                            "ajiteImageString" : self.imageName
                        ])
                    for addingUser in self.addingMembers{
                        self.userRef.document(addingUser.documentID)
                        .collection("invitation").document(addingUser.documentID).setData([
                                       "host" : myUser.name,
                                       "stateInvite" : 0
                                       ])
                    }
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AjiteRoomViewController{
        vc.currentAjite = tempAjite
        } else if let vc = segue.destination as? FriendsToAjiteViewController {
            vc.delegate = self
            vc.vcindex = 0
        }
    }
    
    //==============필요한 Outlet 과 변수들================
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
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "members", for: indexPath) as! membersToAddTableViewCell
        cell.memberName.text = addingMembers[indexPath.row].name
        let data = try? Data(contentsOf: URL(string: addingMembers[indexPath.row].profileImageURL)!)
        cell.memberImage.image = UIImage(data: data!)
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
     indexPath: IndexPath) -> CGFloat {
             return 60
          }
    
}

