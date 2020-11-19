//
//  PlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/28.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PlaylistViewController: UIViewController {
    
    //현재 들어와있는 플레이리스트의 주인
    var currentUser = User()
    //현재 플레이리스트
    var playlist = Playlist()
    //유튜브 플레이어
    var youtubePlayerVC: YoutubePlayerViewController!

    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var songTable: UITableView!
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistName.text = playlist.playlistName
        self.songTable.dataSource = self
        self.songTable.delegate = self
       
    }
    
    override func viewDidAppear (_ animated: Bool){
//        self.getData()
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
        //본인의, 선택한 플레이리스트의, 노래들을 불러온다.
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").document(playlist.id)
            .collection("songs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //우선 전에 받아왔던 노래 정보들을 다 삭제한다.
                self.playlist.songs.removeAll()
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
                    self.playlist.songs.append(temSong)
                }
                print("The number of songs is \(self.playlist.songs.count)")
                DispatchQueue.main.async{
                    //새로 받아온 정보로 테이블 업데이트
                    self.songTable.reloadData()
                    self.youtubePlayerVC.youtubeVideos = self.playlist
                    self.youtubePlayerVC.loadFirstSong()
                }
            }
        }
    }
    
    func deleteSong(index: Int) {
        //선택한 노래를 현재 플레이리스트로부터 삭제한다.
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").document(playlist.id)
            .collection("songs").document(playlist.songs[index].songID)
            .delete()
    }
    
    func reduceSongNum() {
        //현재 플레이리스트의 노래 개수를 하나 줄인다.
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").document(playlist.id).updateData([
                "songNum" : FieldValue.increment(Int64(-1))
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("SongNum successfully updated")
                }
        }
    }
    
    // ==================================================================>
    
}

extension PlaylistViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = songTable.dequeueReusableCell(withIdentifier: "songListTableViewCell", for: indexPath) as! songListTableViewCell
        //해당 노래 이름을 라벨에 적음
        cell.songName.text = playlist.songs[indexPath.row].name
        //해당 노래의 아티스트(채널) 이름을 라벨에 적음
        cell.channelName.text = playlist.songs[indexPath.row].artist
        //cell.cellDelegate = self
        //cell.index = indexPath
        cell.layer.masksToBounds = true
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard currentUser.documentID == myUser.documentID else { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        //선택한 노래를 현재 플레이리스트로부터 삭제한다.
        self.deleteSong(index: indexPath.row)
        //현재 플레이리스트의 노래 개수를 하나 줄인다.
        self.reduceSongNum()
        
        //현재 플레이리스트를 담고 있는 플레이리스트 변수에서도 해당 노래를 제거한다.
        playlist.songs.remove(at: indexPath.row)
        //테이블에서도 해당 노래를 제거한다.
        songTable.deleteRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songTable.deselectRow(at: indexPath, animated: true)
        youtubePlayerVC.playCertainVideo(indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension PlaylistViewController : UITableViewDelegate{
    
}
