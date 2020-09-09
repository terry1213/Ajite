//
//  AddedFriendsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class AddedFriendsTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var circle: UIButton!
    @IBOutlet weak var addedFriendsProfile: CircleImageView!
    @IBOutlet weak var addedMembersLabel: UILabel!
    
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

//소속:
//Description:
