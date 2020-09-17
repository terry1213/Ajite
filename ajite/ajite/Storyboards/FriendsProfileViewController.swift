//
//  FriendsProfileViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/13.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class FriendsProfileViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    var currentUser = User()
    
    @IBOutlet weak var friendsProfileImage: CircleImageView!
    @IBOutlet weak var friendsName: UILabel!
    @IBOutlet weak var friendsBio: UILabel!
    @IBOutlet weak var friendsPlaylist: UITableView!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendsPlaylist.delegate = self
        self.friendsPlaylist.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        //Label에 친구 이름 적기
        self.friendsName.text = currentUser.name
        //Label에 친구 biography 적기
        self.friendsBio.text = currentUser.bio
        //UIImage에 친구 프로필 사진 넣기
        let data = try? Data(contentsOf: URL(string: currentUser.profileImageURL)!)
        self.friendsProfileImage.image = UIImage(data: data!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "toPlaylist" else {
//            return
//        }
//        guard let sendingPlaylist = sender as? Playlist else {
//            return
//        }
//        guard let destination = segue.destination as? PlaylistSongListViewController else {
//            return
//        }
//        //플레이리스트 내부 뷰에 플레이리스트 전송
//        destination.source = sendingPlaylist
//        //플레이리스트 내부 뷰에 플레이리스트 주인 정보 전송
//        destination.currentUser = currentUser
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func getData(){
        //현재 유저의 documentID를 통해 해당 유저 소유의 플레이리스트 목록에 접근
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.currentUser.playlists.removeAll()
                    //임시로 저장할 플레이리스트 변수 선언
                    var temPlaylist : Playlist
                    var count = 0
                    for document in querySnapshot!.documents {
                        //임시 플레이리스트 생성
                        temPlaylist = Playlist()
                        let data = document.data()
                        //플레이리스트 이름 저장
                        temPlaylist.playlistName = data["name"] as! String
                        //플레이리스트의 노래 개수 저장
                        temPlaylist.songNum = data["songNum"] as! Int
                        //플레이리스트의 documentID 저장
                        temPlaylist.id = document.documentID
                        //현재 유저의 플레이리스트 목록에 추가
                        self.currentUser.playlists.append(temPlaylist)
                        count += 1
                        //모든 플레이리스트를 불러왔을 경우
                        if count == querySnapshot!.documents.count {
                            //테이블에 불러온 정보를 보여준다.
                            self.friendsPlaylist.reloadData()
                        }
                    }
                }
            }
    }
    
    // ==================================================================>
    
}

extension FriendsProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.playlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsPlaylist.dequeueReusableCell(withIdentifier: "FriendsPlaylistTableViewCell", for: indexPath) as! FriendsPlaylistTableViewCell
        //해당 플레이리스트 이름을 라벨에 적음
        cell.playlistName.text = currentUser.playlists[indexPath.row].playlistName
        //해당 플레이리스트에 속한 노래의 개수를 적음
        cell.numberOfSongs.text = "\(currentUser.playlists[indexPath.row].songNum) songs"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //보낼 플래이리스트를 담는다.
        let dataToSend = currentUser.playlists[indexPath.row]
        //플레이리스트 내부 뷰로 이동
        self.performSegue(withIdentifier: "toPlaylist", sender: dataToSend)
    }

    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        userPlaylistsTableView.deselectRow(at: indexPath, animated: true)
    //    }
    
}
