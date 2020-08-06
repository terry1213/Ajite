//
//  memberInAjiteTableViewCell.swift
//  
//
//  Created by 노은솔 on 2020/08/06.
//

import UIKit

class memberInAjiteTableViewCell: UITableViewCell {

    @IBOutlet weak var memberProfile: CircleImageView!
    @IBOutlet weak var memberName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
