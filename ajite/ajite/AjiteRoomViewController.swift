//
//  AjiteRoomViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class AjiteRoomViewController: UIViewController {

    @IBOutlet var popUpView: UIView!
    @IBOutlet var blurEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect.bounds = self.view.bounds
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9 , height: self.view.bounds.height * 0.6)
        popUpView.layer.cornerRadius = 40
        // Do any additional setup after loading the view.
    }
    @IBAction func add(_ sender: Any) {
        animateIn(desiredView: blurEffect)
        animateIn(desiredView: popUpView)
    }
    
 
    
    @IBAction func finished(_ sender: Any) {
        animateOut(desiredView: popUpView)
        animateOut(desiredView: blurEffect)
    }
    
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

    func animateOut(desiredView:UIView){
         UIView.animate(withDuration: 0.6, animations: {desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
         desiredView.alpha = 0}, completion: { _ in
             desiredView.removeFromSuperview()
        })
    }
    
}
