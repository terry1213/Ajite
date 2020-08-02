//
//  TabBarMenuViewController.swift
//  ajite
//
//  Created by 임연우 on 2020/07/31.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class TabBarMenuViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 2
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*extension TabBarMenuViewController : UITabBarControllerDelegate{
    public func tabBarController (tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController)->Bool{
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView : UIView = viewController.view
        if fromView == toView{
            return false
        }
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve)
        return true
    }
}
*/
