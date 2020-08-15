//
//  songTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/06.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

protocol PlaylistSongListProtocol {
    //해당 노래를 플레이리스트에 추가할 것이라고 table view controller에 알려준다.
    func toAddToPlaylist(index: Int)
    //해당 노래를 유튜브 플레이어 통해서 재생할 것이라고 table view controller에 알려준다.
    func toYoutubePlayer(index: Int)
}

class SongTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    var cellDelegate: PlaylistSongListProtocol?
    var index: IndexPath?
    weak var delegate : songTableViewCellDelegate?
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func plusTouched(_ sender: Any) {
        //해당 노래를 플레이리스트에 추가할 것이라고 table view controller에 알려준다.
        cellDelegate?.toAddToPlaylist(index: (index?.row)!)
    }
    
    @IBAction func youtubeTouched(_ sender: Any) {
        //해당 노래를 유튜브 플레이어 통해서 재생할 것이라고 table view controller에 알려준다.
        cellDelegate?.toYoutubePlayer(index: (index?.row)!)
    }
    
    // ==================================================================>

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

protocol songTableViewCellDelegate: AnyObject{
    func toYoutubePlayer(index: Int)
}
//소속: PlaylistSongListViewController
//Description: 플레이리스트 내에 들어있는 곡들을 볼러와준다

