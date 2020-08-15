//
//  UserTableViewCell.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

protocol TableViewUser {
    func onClickCell(index: Int)
}

class UserTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    var cellDelegate: TableViewUser?
    weak var delegate : UserTableViewCellDelegate?
    var index: IndexPath?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var userProfileImage: CircleImageView!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func sendRequest(_ sender: UIButton) {
        cellDelegate?.onClickCell(index: (index?.row)!)
    }
    
    @IBAction func popUpAlert(_ sender: Any) {
        if let delegate = delegate{
            self.delegate?.sendMessage(self)
        }
    }
    
    // ==================================================================>
    
}

protocol UserTableViewCellDelegate : AnyObject{
    func sendMessage(_ UserTableViewCell: UserTableViewCell)
}
