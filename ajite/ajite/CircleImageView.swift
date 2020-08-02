//
//  CircleImageView.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    self.layer.borderWidth = 1.0
    self.layer.masksToBounds = false
    self.layer.cornerRadius = self.frame.size.width/2
    self.clipsToBounds = true
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
