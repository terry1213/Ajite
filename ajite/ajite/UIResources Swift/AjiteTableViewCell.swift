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
    @IBOutlet weak var numberOfMembers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
