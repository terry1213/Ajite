//
//  popup.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/03.
//  Copyright © 2020 ajite. All rights reserved.
//
import UIKit

class Popup : UIView{
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .gray
        self.frame = UIScreen.main.bounds
        
        
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
}
