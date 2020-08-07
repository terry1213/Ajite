//
//  PlaylistTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/05.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var numberOfSongsInPlaylist: UILabel!
    @IBOutlet weak var playlistImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//소속: PlaylistViewController
//Description: 현재 유저가 소유하고 있는 개인 플레이리스트들을 보여준다

