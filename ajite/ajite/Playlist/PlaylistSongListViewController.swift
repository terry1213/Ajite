//
//  PlaylistSongListViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/03.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase

var songs: [Song] = []

class PlaylistSongListViewController: UIViewController {
    
    //outlet & variables
    var source = Playlist()
    @IBOutlet weak var songListTableView: UITableView!
    @IBOutlet weak var playlistName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistName.text = source.playlistName
        self.songListTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear (_ animated: Bool){
        getData()
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .none
       }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func getData(){
        //본인의, 선택한 플레이리스트의, 노래들을 불러온다.
        db
            .collection("users").document(UserDefaults.standard.string(forKey: "userID")!)
            .collection("playlists").document(source.id)
            .collection("songs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //우선 전에 받아왔던 노래 정보들을 다 삭제한다.
                self.source.songs.removeAll()
                //정보를 받아오기 위한 임시 노래 선언
                var temSong: Song
                //firestore에서 현재 플레이리스트에 속한 노래를 전부 불러와서 하나하나씩 처리한다.
                for document in querySnapshot!.documents {
                    //다음 노래를 담기 위한 임시 노래 생성
                    temSong = Song()
                    //노래 이름 받기
                    temSong.name = document.data()["name"] as! String
                    //노래 아티스트(채널 이름) 이름 받기
                    temSong.artist = document.data()["artist"] as! String
                    //노래 썸네일 이미지의 url 받기
                    temSong.thumbnailImageUrl = document.data()["thumbnailImageUrl"] as! String
                    //노래 비디오의 ID 받기
                    temSong.videoID = document.data()["videoID"] as! String
                    temSong.songID = document.documentID
                    //노래 목록에 받아온 노래 추가
                    self.source.songs.append(temSong)
                }
                print("The number of playlists is \(playlists.count)")
                DispatchQueue.main.async{
                    //새로 받아온 정보로 테이블 업데이트
                    self.songListTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func pressedPlus(_ sender: Any) {
       performSegue(withIdentifier: "addToPlaylistSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShareSongsViewController {
            vc.playlistID = source.id
        }
    }
}

extension PlaylistSongListViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = songListTableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! songTableViewCell
        //해당 노래 이름을 라벨에 적음
        cell.songName.text = source.songs[indexPath.row].name
        //해당 노래의 아티스트(채널) 이름을 라벨에 적음
        cell.artistName.text = source.songs[indexPath.row].artist
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 60
         }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        //선택한 노래를 현재 플레이리스트로부터 삭제한다.
        db
            .collection("users").document(UserDefaults.standard.string(forKey: "userID")!)
            .collection("playlists").document(source.id)
            .collection("songs").document(source.songs[indexPath.row].songID)
            .delete()
        source.songs.remove(at: indexPath.row)
        songListTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}
