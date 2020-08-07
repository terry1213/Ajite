//
//  AjiteRoomViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class AjiteRoomViewController: UIViewController {
    
    var currentAjite = Ajite()
    @IBOutlet weak var ajiteName: UILabel!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var blurEffect: UIVisualEffectView!
    @IBOutlet weak var sharedSongsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect.bounds = self.view.bounds
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9 , height: self.view.bounds.height * 0.6)
        popUpView.layer.cornerRadius = 40
        
        //아지트이름 뽑아옴
        ajiteName.text = currentAjite.name
        //shared Songs View 에 섀도우 집어넣음
        sharedSongsView.layer.shadowColor = UIColor.gray.cgColor
        sharedSongsView.layer.shadowOpacity = 0.45
        sharedSongsView.layer.shadowOffset = .zero
        sharedSongsView.layer.shadowRadius = 5
        //멤버스뷰에 섀도우 집어넣음
        // Do any additional setup after loading the view.
    }
//===================애니메이션 코드=================
    // when you want to add members
    @IBAction func add(_ sender: Any) {
        animateIn(desiredView: blurEffect)
        animateIn(desiredView: popUpView)
    }
    
//after you are finished adding members
    @IBAction func finished(_ sender: Any) {
        animateOut(desiredView: popUpView)
        animateOut(desiredView: blurEffect)
    }
 //animation for popup
    func animateIn(desiredView: UIView){
        let backgroundview = self.view!
        backgroundview.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundview.center
        UIView.animate(withDuration: 0.6, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
//animation for fading out the popup
    func animateOut(desiredView:UIView){
         UIView.animate(withDuration: 0.6, animations: {desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
         desiredView.alpha = 0}, completion: { _ in
             desiredView.removeFromSuperview()
        })
    }
    
    
    //animation for when it is touched out of bounds
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        
        if touch.view != popUpView{
            animateOut(desiredView: popUpView)
            animateOut(desiredView: blurEffect)
        }
    }
    
 //=======================애니메이션 끝===================//
    
    
    @IBAction func pressedMembers(_ sender: Any) {
    performSegue(withIdentifier: "viewMembers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         switch segue.identifier {
               case "viewMembers":
                   var vc = segue.destination as! MemberViewController
                   vc.memberViewAjite = currentAjite
               default:
                   print("Undefined Segue indentifier: \(segue.identifier)")
               }

    }

    
}
