//
//  AddToPlaylistTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

protocol AddToPlaylistProtocol {
    //체크했다는 것을 table view controller에 알려준다.
    func checkPlaylist(index: Int)
    //체크가 해제되었다는 것을 table view controller에 알려준다.
    func uncheckPlaylist(index: Int)
}

class AddToPlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var playlistName: UILabel!
    var checked : Bool = false
    var cellDelegate: AddToPlaylistProtocol?
    var index: IndexPath?
    
    //weak var delegate : AddToPlaylistTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //check box를 클릭했을 때
    @IBAction func checkBox(_ sender: UIButton) {
        //체크가 되어 있지 않다면,
        if checked == false {
            //버튼 이미지를 체크된 것으로 교체하고
            checkBoxButton.setImage(UIImage(named: "checked"), for: .normal)
            //체크했다는 것을 table view controller에 알려준다.
            cellDelegate?.checkPlaylist(index: (index?.row)!)
        }
        //체크가 되어 있다면,
        else {
            //버튼 이미지를 체크되지 않은 것으로 교체하고
            checkBoxButton.setImage(UIImage(named: "check"), for: .normal)
            //체크가 해제되었다는 것을 table view controller에 알려준다.
            cellDelegate?.uncheckPlaylist(index: (index?.row)!)
        }
        checked.toggle()
    }
}

//소속: AddToPlaylistViewController
//Description: 노래를 자기 플레이리스트에 추가하고 싶을때 어떤 플레이리스트에 추가할 수 있는지 보여주는 TableCell
