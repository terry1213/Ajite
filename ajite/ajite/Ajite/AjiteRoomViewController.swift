//
//  AjiteRoomViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

//:::::::::::::아지트 방 안을 보여주는 뷰 컨트롤러 :::::::::::


class AjiteRoomViewController: UIViewController {
    
    
   //아웃렛과 변수들
    var currentAjite = Ajite()
    @IBOutlet weak var ajiteName: UILabel!
    @IBOutlet weak var sharedSongsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //아지트이름 뽑아옴
        ajiteName.text = currentAjite.name
        //shared Songs View 에 섀도우 집어넣음
        sharedSongsView.layer.shadowColor = UIColor.gray.cgColor
        sharedSongsView.layer.shadowOpacity = 0.45
        sharedSongsView.layer.shadowOffset = .zero
        sharedSongsView.layer.shadowRadius = 5

    }
    
    
    

    
    
    //아지트 오른쪽 상단에 있는 member 버튼을 누르면 이 함수가 불러짐
    @IBAction func pressedMembers(_ sender: Any) {
    performSegue(withIdentifier: "viewMembers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         switch segue.identifier {
               case "viewMembers":
                   var vc = segue.destination as! MemberViewController
                   vc.memberViewAjite = currentAjite
               default:
                   print("Undefined Segue indentifier: \(segue.identifier)")
               }

    }

    
}
