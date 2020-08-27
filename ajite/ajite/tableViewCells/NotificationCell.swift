//
//  notificationCell.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/11.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet var ajiteName: UILabel!
    @IBOutlet weak var 초대자: UILabel!
    @IBOutlet weak var timeInvited: UILabel!
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
