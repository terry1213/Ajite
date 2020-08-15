//
//  PlaylistTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/05.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var numberOfSongsInPlaylist: UILabel!
    @IBOutlet weak var playlistImage: UIImageView!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//소속: PlaylistViewController
//Description: 현재 유저가 소유하고 있는 개인 플레이리스트들을 보여준다

