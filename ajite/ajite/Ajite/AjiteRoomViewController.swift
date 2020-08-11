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
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var songCollection: UICollectionView!
    //keyboard 아무 곳이나 터치하면 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData() {
        db
            .collection("ajites").document(currentAjite.ajiteID)
            .collection("sharedSongs").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.currentAjite.sharedSongs.removeAll()
                    var temSong : Song
                    var count = 0
                    for document in querySnapshot!.documents {
                        temSong = Song()
                        let data = document.data()
                        temSong.name = data["name"] as! String
                        temSong.artist = data["artist"] as! String
                        temSong.thumbnailImageUrl = data["thumbnailImageUrl"] as! String
                        temSong.videoID = data["videoID"] as! String
                        temSong.songID = document.documentID
                        self.currentAjite.sharedSongs.append(temSong)
                        count += 1
                        if count == querySnapshot!.documents.count {
                            self.songCollection.reloadData()
                        }
                    }
                }
            }
    }
    
    //아지트 오른쪽 상단에 있는 member 버튼을 누르면 이 함수가 불러짐
    @IBAction func pressedMembers(_ sender: Any) {
        performSegue(withIdentifier: "viewMembers", sender: currentAjite)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "viewMembers":
            let vc = segue.destination as! MemberViewController
            vc.memberViewAjite = currentAjite
        case "shareSong":
            let vc = segue.destination as! ShareSongsViewController
            vc.ajiteID = currentAjite.ajiteID
        default:
            print("Undefined Segue indentifier: \(String(describing: segue.identifier))")
            return
        }

    }
 
}

extension AjiteRoomViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAjite.sharedSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = view.frame.size.width/1.3
        return CGSize (width: width , height: width/2.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCollectionViewCell", for: indexPath) as! SongCollectionViewCell
        cell.songName.text = currentAjite.sharedSongs[indexPath.row].name
       
        cell.artistName.text = currentAjite.sharedSongs[indexPath.row].artist
        let data = try? Data(contentsOf: URL(string: currentAjite.sharedSongs[indexPath.row].thumbnailImageUrl)!)
        DispatchQueue.main.async {
            cell.songImage.image = UIImage(data: data!)
        }
        return cell
    }
}
