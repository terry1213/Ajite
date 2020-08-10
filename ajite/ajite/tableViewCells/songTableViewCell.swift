//
//  songTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/06.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

protocol PlaylistSongListProtocol {
    func toAddToPlaylist(index: Int)
    func toYoutubePlayer(index: Int)
}

class songTableViewCell: UITableViewCell {

    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    var cellDelegate: PlaylistSongListProtocol?
    var index: IndexPath?
    weak var delegate : songTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func plusTouched(_ sender: Any) {
        cellDelegate?.toAddToPlaylist(index: (index?.row)!)
    }
    
    @IBAction func youtubeTouched(_ sender: Any) {
        cellDelegate?.toYoutubePlayer(index: (index?.row)!)
    }
}

protocol songTableViewCellDelegate: AnyObject{
    func toYoutubePlayer(index: Int)
}
//소속: PlaylistSongListViewController
//Description: 플레이리스트 내에 들어있는 곡들을 볼러와준다

