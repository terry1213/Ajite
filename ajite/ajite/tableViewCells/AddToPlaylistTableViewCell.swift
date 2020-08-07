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
       //self.checkBoxButton.addTarget(self, action: #selector(pressedCheckBox(_:)), for: .touchUpInside)
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
