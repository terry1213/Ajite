//
//  SongCollectionViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var sharedMember: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var tappedPlus: UIButton!
    var cellDelegate: PlaylistSongListProtocol?
    var index: IndexPath?
    
    @IBAction func plusTouched(_ sender: Any) {
        cellDelegate?.toAddToPlaylist(index: (index?.row)!)
    }
    
    @IBAction func youtubeTouched(_ sender: Any) {
        cellDelegate?.toYoutubePlayer(index: (index?.row)!)
    }
}
