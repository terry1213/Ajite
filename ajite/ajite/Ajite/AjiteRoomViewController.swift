//
//  AjiteRoomViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

//:::::::::::::아지트 방 안을 보여주는 뷰 컨트롤러 :::::::::::

var sharedSongs = [Song]()
class AjiteRoomViewController: UIViewController {
    
    
   //아웃렛과 변수들
    var currentAjite = Ajite()
    @IBOutlet weak var ajiteName: UILabel!
    @IBOutlet weak var sharedSongsView: UIView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var songCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = songCollection.collectionViewLayout as! UICollectionViewFlowLayout
        songCollection.translatesAutoresizingMaskIntoConstraints = false
        songCollection.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: "collection")
        songCollection.delegate = self
        songCollection.dataSource = self
        //아지트이름 뽑아옴
        ajiteName.text = currentAjite.name
        //shared Songs View 에 섀도우 집어넣음
        sharedSongsView.layer.shadowColor = UIColor.gray.cgColor
        sharedSongsView.layer.shadowOpacity = 0.45
        sharedSongsView.layer.shadowOffset = .zero
        sharedSongsView.layer.shadowRadius = 5
        var random = arc4random_uniform(2)
        let randomBackground = "scroll\(random)"
        background.image = UIImage(named:randomBackground)
    }
    
    
    

    
    
    //아지트 오른쪽 상단에 있는 member 버튼을 누르면 이 함수가 불러짐
    @IBAction func pressedMembers(_ sender: Any) {
    performSegue(withIdentifier: "viewMembers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         switch segue.identifier {
               case "viewMembers":
                   let vc = segue.destination as! MemberViewController
                   vc.memberViewAjite = currentAjite
               default:
                print("Undefined Segue indentifier: \(String(describing: segue.identifier))")
               }

    }

    
}

extension AjiteRoomViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sharedSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = view.frame.size.width/1.3
        return CGSize (width: width , height: width/2.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! SongCollectionViewCell
        return cell
    }
}
