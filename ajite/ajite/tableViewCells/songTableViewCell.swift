//
//  songTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/06.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class songTableViewCell: UITableViewCell {

    
    @IBOutlet weak var artistName: UILabel!
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

//소속: PlaylistSongListViewController
//Description: 플레이리스트 내에 들어있는 곡들을 볼러와준다
