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

class PlaylistSongListViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    //유튜브 플레이어를 올리기 위한 UIView Controller이다.
    let youtubePlayerViewController = YoutubePlayerViewController()
    //유튜브 플레이어가 올라올 시, 노래 리스트 테이블의 위치를 나타내는 constraint
    var songListShortConstraint: NSLayoutConstraint?
    //유튜브 플레이어가 없을 시, 노래 리스트 테이블의 위치를 나타내는 constraint
    var songListFullConstraint: NSLayoutConstraint?
    //현재 들어와있는 플레이리스트의 주인
    var currentUser = User()
    //현재 플레이리스트
    var source = Playlist()
    //유튜브 플레이어에 보낼 노래의 인덱스
    var nextSourceIndex : Int = -1
    
    @IBOutlet weak var songListTableView: UITableView!
    @IBOutlet weak var playlistName: UILabel!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistName.text = source.playlistName
        self.songListTableView.dataSource = self
        self.songListTableView.delegate = self
        //
        setSongListTableViewConstraints()
        //유뷰트에 현재 플레이리스트를 보낸다.
        youtubePlayerViewController.youtubeVideos = source
    }
    
    override func viewDidAppear (_ animated: Bool){
        self.getData()
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
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
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
    
    func deleteSong(index: Int) {
        //선택한 노래를 현재 플레이리스트로부터 삭제한다.
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").document(source.id)
            .collection("songs").document(source.songs[index].songID)
            .delete()
    }
    
    func reduceSongNum() {
        //현재 플레이리스트의 노래 개수를 하나 줄인다.
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
    }
    
    // ==================================================================>
    
    func addChildVC() {
        addChild(youtubePlayerViewController)
        UIView.transition(with: self.view, duration: 0.8, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.youtubePlayerViewController.view)
        }, completion: nil)
        youtubePlayerViewController.didMove(toParent: self)
        setYoutubePlayerVCConstraints()
    }
    
    //유튜브 플레이어 뷰 constraints 초기 설정
    func setYoutubePlayerVCConstraints() {
        youtubePlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        youtubePlayerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
        youtubePlayerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        youtubePlayerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        youtubePlayerViewController.view.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //노래 리스트 테이블 뷰 constraints 초기 설정
    func setSongListTableViewConstraints() {
        songListTableView.translatesAutoresizingMaskIntoConstraints = false
        songListFullConstraint = view.constraints.first { $0.identifier == "SongListTableViewTop" }
        songListFullConstraint?.isActive = true
        songListShortConstraint = songListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 290)
        songListShortConstraint?.isActive = false
    }
    
    //노래 리스트 테이블 뷰를 유튜브 플레이어에 생성과 삭제에 맞춰서 toggle
    func toggleSongListTableViewConstraints() {
        songListFullConstraint?.isActive.toggle()
        songListShortConstraint?.isActive.toggle()
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
        let cell = songListTableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        //해당 노래 이름을 라벨에 적음
        cell.songName.text = source.songs[indexPath.row].name
        //해당 노래의 아티스트(채널) 이름을 라벨에 적음
        cell.artistName.text = source.songs[indexPath.row].artist
        cell.cellDelegate = self
        cell.index = indexPath
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
        source.songs.remove(at: indexPath.row)
        //테이블에서도 해당 노래를 제거한다.
        songListTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
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
        //child view controller가 존재한다면
        if self.children.count > 0 {
            //유뷰트 플레이어 뷰 컨트롤러의 노래와 지금 재생하려는 노래가 같을 경우(index가 같은 경우) -> 이미 해당 영상이 재생되고 있는 상황이기 때문에 유튜브 플레이어를 내린다.
            if youtubePlayerViewController.index == index {
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                   viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            //유뷰트 플레이어 뷰 컨트롤러의 노래와 지금 재생하려는 노래가 다른 경우(index가 다른 경우)
            else {
                //유뷰트 플레이어 뷰 컨트롤러의 인덱스를 재생하려는 노래의 인덱스로 바꿔주고
                youtubePlayerViewController.index = index
                //해당 노래를 튼다.
                youtubePlayerViewController.playCertainVideo()
                return
            }
        }
        //child view controller가 없다면
        else {
            //child view controller를 추가하고
            addChildVC()
            //유뷰트 플레이어 뷰 컨트롤러의 노래와 지금 재생하려는 노래가 다른 경우(index가 다른 경우)
            if youtubePlayerViewController.index != index {
                //유뷰트 플레이어 뷰 컨트롤러의 인덱스를 재생하려는 노래의 인덱스로 바꿔주고
                youtubePlayerViewController.index = index
                //해당 노래를 튼다.
                youtubePlayerViewController.playCertainVideo()
            }
        }
        //노래 리스트 테이블 뷰의 constraints를 toggle시킨다.
        toggleSongListTableViewConstraints()
    }
    
}
