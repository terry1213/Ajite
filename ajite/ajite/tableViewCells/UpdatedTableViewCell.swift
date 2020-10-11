//
//  UpdatedTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/09.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class UpdatedTableViewCell: UITableViewCell {

    @IBOutlet weak var ellipsis: UIButton!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        self.ellipsis.transform = CGAffineTransform(rotationAngle: 90)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func otherMenu(_ sender: Any) {
   print("pressed")
    }
}
