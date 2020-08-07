//
//  AddToPlaylistTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class AddToPlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var playlistName: UILabel!
    
    //weak var delegate : AddToPlaylistTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//소속: AddToPlaylistViewController
//Description: 노래를 자기 플레이리스트에 추가하고 싶을때 어떤 플레이리스트에 추가할 수 있는지 보여주는 TableCell
