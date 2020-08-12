//
//  AjiteTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/05.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class AjiteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ajiteImage: UIImageView!
    @IBOutlet weak var ajiteName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//소속: AjiteViewController
//Description: 현재 유저가 소속되어 있는 아지트 정보를 담고 있는 셀
