//
//  membersToAddTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/11.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class membersToAddTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberImage: CircleImageView!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // ==================================================================>
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
//소속: CreateAjiteViewConrtoller
//Description: 생성될 아지트 화면에 확실하게 추가되는 멤버들을 보여주는 화면
