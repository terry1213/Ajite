//
//  ViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/25.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController{

    //keyboard 아무 곳이나 터치하면 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBOutlet weak var backgroundImage0: UIImageView!
    
    var topFrame = CGRect()
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    override func viewWillAppear(_ animated: Bool){
       self.backgroundImage0.transform = .identity
        animateView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animateView(){
        UIView.animate(withDuration: 8.0, delay: 0.0, options:[ .curveLinear, .repeat] , animations: {
                      self.topFrame = self.backgroundImage0.frame

            self.topFrame.origin.y -= self.topFrame.size.height/1.2
                            
                              
                      self.backgroundImage0.frame = self.topFrame
                            
        }, completion: { finished in
            self.backgroundImage0.frame.origin.y += self.topFrame.size.height/1.2     })
    }
    override func viewWillDisappear(_ animated: Bool) {
           self.view.layer.removeAllAnimations()
       }
}
