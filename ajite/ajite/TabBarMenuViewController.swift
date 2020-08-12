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
        self.selectedIndex = 0
        delegate = self
        // Do any additional setup after loading the view.
    }

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

extension TabBarMenuViewController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
