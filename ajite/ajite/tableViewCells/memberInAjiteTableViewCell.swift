//
//  memberInAjiteTableViewCell.swift
//  
//
//  Created by 노은솔 on 2020/08/06.
//

import UIKit

protocol memberTableView{
    func OnClickCell(index: Int)
}

class memberInAjiteTableViewCell: UITableViewCell {

    @IBOutlet weak var memberProfile: CircleImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    var cellDelegate: memberTableView?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //+버튼을 누를시 동작하는 메서드
    @IBAction func sendMemberToAjite(_ selected: Any) {
        cellDelegate?.OnClickCell(index: (index?.row)!)
    }

}

//소속: MemberViewController
//Description: 소속되어 있는 아지트 방에 들어가면 오른쪽 상단에 멤버 아이콘이 있다. 여기를 누르면 MemberViewController로 이동하는데 아지트에 소속되어 있는 멤버들을 리스트뷰로 보여준다. 이 테이블 멤버이다. 
