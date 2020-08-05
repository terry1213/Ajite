//
//  CreateAjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit


class MemberCell : UITableViewCell{
    
    @IBOutlet weak var profilepicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
          // Initialization code
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
    }
   
    
    
}


class CreateAjiteViewController: UIViewController {

    
    //"add" 버튼을 누르면 들어가는 애니메이션이 동작한다
    @IBAction func add(_ sender: Any) {
        animateIn(desiredView: blurEffect)
        animateIn(desiredView: popUpView)
    }
    //popup 에 있는 "add" 버튼을 누르면 애니메이션 동작함
    @IBAction func finished(_ sender: Any) {
        animateOut(desiredView: popUpView)
        animateOut(desiredView: blurEffect)
    }
  //변수들
    
    
    @IBOutlet weak var addedFriendsTableView: UITableView!
    @IBOutlet weak var searchFriendsTableView: UITableView!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var searchFriendsField: UITextField!
    @IBOutlet weak var ajiteName: UITextField!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var blurEffect: UIVisualEffectView!
    var name = ""
    
//로드가 되었을 때
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect.bounds = self.view.bounds
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9 , height: self.view.bounds.height * 0.6)
    }
   //animate in a specific view
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
    

    @IBAction func pressedEnter(_ sender: Any) {
        let newAjite = Ajite()
        newAjite.name = ajiteName.text!
        //아지트 text field 안에 아무 것도 안들어가있을 때 즉 whitespace로만 이루어졌을 때
        if newAjite.name.trimmingCharacters(in: .whitespaces).isEmpty{
            //alert 메세지가 뜬다
            let alert = UIAlertController(title: "Empty Name Field", message: "Your Ajite must have a name.", preferredStyle: .alert)
            //alert 액션이다.
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")}))
            
         self.present(alert, animated: true, completion: nil)
            return
        }
        else{
        newAjite.numberOfMembers = newAjite.members.count + 1
        ajite.append(newAjite)
            //"create" segue 를 이용해 그 세그와 연결된 뷰 컨트롤러로 이동함
        performSegue(withIdentifier: "create", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! AjiteRoomViewController
        vc.nameOfAjite = ajiteName.text!
    }
}
