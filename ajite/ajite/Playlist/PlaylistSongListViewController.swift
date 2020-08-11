//
//  PlaylistSongListViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/03.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase
import youtube_ios_player_helper
import FirebaseFirestore

//var songs: [Song] = []

class PlaylistSongListViewController: UIViewController {
    
    //outlet & variables
    let youtubePlayerViewController = YoutubePlayerViewController()
    var songListShortConstraint: NSLayoutConstraint?
    var songListFullConstraint: NSLayoutConstraint?
    var currentUser = User()
    var source = Playlist()
    var nextSourceIndex : Int = -1
    @IBOutlet weak var songListTableView: UITableView!
    @IBOutlet weak var playlistName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistName.text = source.playlistName
        self.songListTableView.dataSource = self
        self.songListTableView.delegate = self
        setSongListTableViewConstraints()
        youtubePlayerViewController.youtubeVideos = source
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear (_ animated: Bool){
        self.getData()
    }
    
    
    func getData(){
        //본인의, 선택한 플레이리스트의, 노래들을 불러온다.
        db
            .collection("users").document(currentUser.documentID)
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
                print("The number of playlists is \(self.source.songs.count)")
                DispatchQueue.main.async{
                    //새로 받아온 정보로 테이블 업데이트
                    self.songListTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShareSongsViewController {
            vc.playlistID = source.id
            vc.listVC = self

        }
        else if let vc = segue.destination as? AddToPlaylistViewController {
            vc.addingSong = source.songs[nextSourceIndex]
             vc.listVC = self
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
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 70
         }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        //선택한 노래를 현재 플레이리스트로부터 삭제한다.
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").document(source.id)
            .collection("songs").document(source.songs[indexPath.row].songID)
            .delete()
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").document(source.id).updateData([
                "songNum" : FieldValue.increment(Int64(-1))
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("SongNum successfully updated")
                }
            }
        source.songs.remove(at: indexPath.row)
        songListTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func addChildVC() {
        addChild(youtubePlayerViewController)
       UIView.transition(with: self.view, duration: 0.8, options: [.transitionCrossDissolve], animations: {
           self.view.addSubview(self.youtubePlayerViewController.view)
              }, completion: nil)
     //  view.addSubview(youtubePlayerViewController.view)
        youtubePlayerViewController.didMove(toParent: self)
        setYoutubePlayerVCConstraints()
    }
    
    func setYoutubePlayerVCConstraints() {
        youtubePlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        youtubePlayerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
        youtubePlayerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        youtubePlayerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        youtubePlayerViewController.view.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    func setSongListTableViewConstraints() {
        songListTableView.translatesAutoresizingMaskIntoConstraints = false
        songListFullConstraint = view.constraints.first { $0.identifier == "SongListTableViewTop" }
        songListFullConstraint?.isActive = true
        songListShortConstraint = songListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 290)
        songListShortConstraint?.isActive = false
    }
    
    func toggleSongListTableViewConstraints() {
        songListFullConstraint?.isActive = !(songListFullConstraint?.isActive)!
        songListShortConstraint?.isActive = !(songListShortConstraint?.isActive)!
    }
}

extension PlaylistSongListViewController : UITableViewDelegate{
    
}

extension PlaylistSongListViewController : PlaylistSongListProtocol {
    func toAddToPlaylist(index: Int) {
        nextSourceIndex = index
        performSegue(withIdentifier: "addToPlaylistSegue", sender: self)
    }
    func toYoutubePlayer(index: Int) {
        if self.children.count > 0 {
            if youtubePlayerViewController.index == index {

                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                 
                   viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            else {
                youtubePlayerViewController.index = index
                youtubePlayerViewController.playCertainVideo()
                return
            }
        }
        else {
            addChildVC()
            if youtubePlayerViewController.index != index {
                youtubePlayerViewController.index = index
                youtubePlayerViewController.playCertainVideo()
            }
        }
        toggleSongListTableViewConstraints()
    }
}
