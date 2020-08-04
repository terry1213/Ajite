//
//  AjiteRoomViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class AjiteRoomViewController: UIViewController {
    var nameOfAjite : String = ""
    
    @IBOutlet weak var ajiteName: UILabel!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var blurEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect.bounds = self.view.bounds
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9 , height: self.view.bounds.height * 0.6)
        popUpView.layer.cornerRadius = 40
        ajiteName.text = nameOfAjite
        // Do any additional setup after loading the view.
    }
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
    
    @IBAction func pressedLeave(_ sender: Any) {
        let removingAjite = ajiteName.text
        var i = 0
        print(ajite)
        for rooms in ajite {
            if rooms.name == removingAjite {
                ajite.remove(at: i)
                _ = navigationController?.popViewController(animated: true)
            } else{
                print(i, rooms.name)
                i+=1
            }
        }
    
    }
    //animation for when it is touched out of bounds
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        
        if touch.view != popUpView{
            animateOut(desiredView: popUpView)
            animateOut(desiredView: blurEffect)
        }
    }
    
}
