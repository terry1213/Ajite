//
//  MyFriendsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var myFriendsName: UILabel!
    @IBOutlet weak var myFriendsProfile: UIImageView!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// 소속: ProfileViewController
//Description: 유저의 친구들을 저장해둔 셀
