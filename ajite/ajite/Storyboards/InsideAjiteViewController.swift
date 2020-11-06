//
//  InsideAjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/13.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import FirebaseFirestore

class InsideAjiteViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    // 현재 아지트
    var currentAjite = Ajite()
    //유튜브 플레이어
    var youtubePlayerVC: YoutubePlayerViewController!
    
    @IBOutlet weak var ajiteName: UILabel!
    @IBOutlet weak var ajiteInfo: UILabel!
    @IBOutlet weak var sharedSongsTable: UITableView!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sharedSongsTable.dataSource = self
        self.sharedSongsTable.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "YoutubePlayerViewController" else {
            return
        }
        guard let destination = segue.destination as? YoutubePlayerViewController else {
            return
        }
        youtubePlayerVC = destination
        self.getData()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func getData(){
        //선택한 아지트의 공유된 노래들을 불러온다.
        db
            .collection("ajites").document(currentAjite.ajiteID)
            .collection("sharedSongs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.currentAjite.sharedSongs.songs.removeAll()
                var temSong : Song
                var count = 0
                for document in querySnapshot!.documents {
                    temSong = Song()
                    let data = document.data()
                    temSong.name = data["name"] as! String
                    temSong.artist = data["artist"] as! String
                    temSong.thumbnailImageUrl = data["thumbnailImageUrl"] as! String
                    temSong.videoID = data["videoID"] as! String
                    temSong.sharedPerson = data["sharedPerson"] as! String
                    temSong.songID = document.documentID
                    self.currentAjite.sharedSongs.songs.append(temSong)
                    count += 1
                    if count == querySnapshot!.documents.count {
                        self.getSharedPerson()
                    }
                }
            }
        }
    }
    
    func getSharedPerson() {
        var count = 0
        for sharedSong in currentAjite.sharedSongs.songs {
            db
                .collection("users").document(sharedSong.sharedPerson).getDocument { (document, error) in
                    if let document = document, document.exists {
                        sharedSong.sharedPerson = document.data()!["name"] as! String
                        count += 1
                        if count == self.currentAjite.sharedSongs.songs.count {
                            DispatchQueue.main.async{
                                //새로 받아온 정보로 테이블 업데이트
                                self.sharedSongsTable.reloadData()
                                self.youtubePlayerVC.youtubeVideos = self.currentAjite.sharedSongs
                                self.youtubePlayerVC.loadFirstSong()
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
        }
    }
    
    // ==================================================================>
    
}

extension InsideAjiteViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAjite.sharedSongs.songs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(self.currentAjite.sharedSongs.songs[0].name)
        let cell = sharedSongsTable.dequeueReusableCell(withIdentifier: "sharedSongsTableViewCell", for: indexPath) as! sharedSongsTableViewCell
        //해당 노래 이름을 라벨에 적음
        cell.videoName.text = currentAjite.sharedSongs.songs[indexPath.row].name
        //해당 노래의 아티스트(채널) 이름을 라벨에 적음
        cell.channelName.text = currentAjite.sharedSongs.songs[indexPath.row].artist
        cell.layer.masksToBounds = true
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sharedSongsTable.deselectRow(at: indexPath, animated: true)
        youtubePlayerVC.playCertainVideo(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension InsideAjiteViewController : UITableViewDelegate{
    
}
