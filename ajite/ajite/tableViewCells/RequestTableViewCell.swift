//
//  RequestTableViewCell.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/09.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

protocol RequestTableViewUser {
    func AcceptClickCell(index: Int)
    func DeclineClickCell(index: Int)
}

class RequestTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    var cellDelegate: RequestTableViewUser?
    var index: IndexPath?
    
    @IBOutlet var nameBox: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func accept(_ sender: Any) {
        cellDelegate?.AcceptClickCell(index: (index?.row)!)
    }
    @IBAction func decline(_ sender: Any) {
        cellDelegate?.DeclineClickCell(index: (index?.row)!)
    }
    
    // ==================================================================>
    
}
