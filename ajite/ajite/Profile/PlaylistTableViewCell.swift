//
//  PlaylistTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var record: UIImageView!
    @IBOutlet weak var youtube: UIImageView!
    @IBOutlet weak var numberOfSongs: UILabel!
    @IBOutlet weak var playlistName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
