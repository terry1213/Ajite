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

class CreateAjiteViewController: UIViewController {
    let db = Firestore.firestore()
    //아지트를 넘겨주기 위해 만든 variable (sort of global within class)
    var tempAjite = Ajite()
    var imageName = String()
     var topFrame = CGRect()//생성되는 아지트에 이미지 집어 넣을때
    
    private let imageViews: [UIImageView] = [.init(), .init()]
   
//==========================애니메이션==========================
    
    
  //Outlet들
 
  
 
  
    @IBOutlet weak var backgroundImage0: UIImageView!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var ajiteName: UITextField!
    //==============필요한 Outlet 과 변수들================
    
    
    
    //로드가 되었을 때
    override func viewDidLoad() {
        super.viewDidLoad()
       let random = arc4random_uniform(4)
       imageName = "\(random)"
        
     
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.backgroundImage0.transform = .identity
        animateView()
        
}
    
    func animateView(){
        UIView.animate(withDuration: 15.0, delay: 0.0, options:[ .curveLinear, .repeat] , animations: {
                      self.topFrame = self.backgroundImage0.frame

                      self.topFrame.origin.y -= self.topFrame.size.height/1.13
                            
                              
                      self.backgroundImage0.frame = self.topFrame
                            
        }, completion: { finished in
            self.backgroundImage0.frame.origin.y += self.topFrame.size.height/1.15
        })
    }
  
//=================여기부터애니메이션=======================//
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.layer.removeAllAnimations()
    }
    
    //"add" 버튼을 누르면 들어가는 애니메이션이 동작한다
/* @IBAction func add(_ sender: Any) {
        animateIn(desiredView: blurEffect)
        animateIn(desiredView: popUpView)
    }
    //popup 에 있는 "add" 버튼을 누르면 애니메이션 동작함
    @IBAction func finished(_ sender: Any) {
        animateOut(desiredView: popUpView)
        animateOut(desiredView: blurEffect)
    }
    
    
    func animateIn (desiredView : UIView){
        let backgroundview = self.view!
        //팝업이 들어오기 전 상태
        backgroundview.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundview.center
        //팝업 애니메이션 후 상태
        UIView.animate(withDuration: 0.6, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                   desiredView.alpha = 1
        })
    }
    
    
    //친구 추가 다했을 때 팝업 창을 닫게 됨
    func animateOut (desiredView: UIView){
        UIView.animate(withDuration: 0.6, animations: {desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0}, completion: { _ in
                desiredView.removeFromSuperview()
        })
        
    }
    
    //다른 곳에 터지 하면 일어남
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        
        if touch.view != popUpView{
            animateOut(desiredView: popUpView)
            animateOut(desiredView: blurEffect)
        }
    }
    
    */
//=================여기까지 애니메이션=======================//
    
    
    
    
    
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
                "ajiteImageString": imageName
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Ajite added with ID: \(ref!.documentID)")
                    
                    self.db
                        .collection("ajites")
                        .document(ref!.documentID)
                        .collection("members").document(myUser.documentID)
                        .setData([
                            "userID" : myUser.userID as Any,
                            "name" : myUser.name as Any
                        ])
                    
                    self.db
                        .collection("users")
                        .document(myUser.documentID)
                        .collection("ajites").document(ref!.documentID)
                        .setData([
                            "name" : self.ajiteName.text as Any,
                            "ajiteImageString" : self.imageName
                        ])
                    
                    let newAjite = Ajite()
                    newAjite.name = self.ajiteName.text!
                    //newAjite.members = []
                    newAjite.sharedSongs = []
                    newAjite.ajiteImageString = self.imageName
                    newAjite.ajiteID = ref!.documentID

                    //"create" segue 를 이용해 그 세그와 연결된 뷰 컨트롤러로 이동함
                    self.tempAjite = newAjite
                    self.performSegue(withIdentifier: "create", sender: self)
                }
            }
        }
    }
    
    
    
    //새로운 멤버 추가하기 ! 이 방법은 아마 난중에 바꿔야할 것 같다.
    func addMember (newAjite: Ajite, newUser: User){
//        if newAjite.members.contains(newUser){
//            let alert = UIAlertController(title: "Existing Member", message: "This member is already part of your Ajite! ", preferredStyle: .alert)
//                //alert 액션이다.
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//                NSLog("The \"OK\" alert occured.")}))
//                
//            self.present(alert, animated: true, completion: nil)
//                return
//        }
//        else{
//            newAjite.members.append(newUser)
//        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! AjiteRoomViewController
        vc.currentAjite = tempAjite
    }
}

