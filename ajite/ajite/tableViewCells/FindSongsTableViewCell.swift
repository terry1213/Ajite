//
//  FindSongsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/13.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class FindSongsTableViewCell: UITableViewCell {


    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var youtubeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
