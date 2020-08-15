//
//  SongCollectionViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell {
    
    // ======================> 변수, outlet 선언
    
    var cellDelegate: PlaylistSongListProtocol?
    var index: IndexPath?
    
    @IBOutlet weak var sharedMember: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var tappedPlus: UIButton!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func plusTouched(_ sender: Any) {
        //플레이리스트에 추가하는 뷰 띄우기
        cellDelegate?.toAddToPlaylist(index: (index?.row)!)
    }
    
    @IBAction func youtubeTouched(_ sender: Any) {
        //유튜브 플레이어에 해당 노래 띄우기
        cellDelegate?.toYoutubePlayer(index: (index?.row)!)
    }
    
    // ==================================================================>
    
}
