//
//  songListTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/28.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class songListTableViewCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
