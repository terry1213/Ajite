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
    
    @IBOutlet var nameBox: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    var cellDelegate: RequestTableViewUser?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func accept(_ sender: Any) {
        cellDelegate?.AcceptClickCell(index: (index?.row)!)
    }
    @IBAction func decline(_ sender: Any) {
        cellDelegate?.DeclineClickCell(index: (index?.row)!)
    }
    
}
