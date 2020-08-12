//
//  FriendProfileViewController.swift
//  ajite
//
//  Created by 임연우 on 2020/08/11.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userPlaylistsTableView: UITableView!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicture: CircleImageView!
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.userPlaylistsTableView.delegate = self
        self.userPlaylistsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        //Label에 친구 이름 적기
        self.userNameLabel.text = currentUser.name
        //Label에 친구 biography 적기
        self.bio.text = currentUser.bio
        //UIImage에 친구 프로필 사진 넣기
        let data = try? Data(contentsOf: URL(string: currentUser.profileImageURL)!)
        self.profilePicture.image = UIImage(data: data!)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.playlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userPlaylistsTableView.dequeueReusableCell(withIdentifier: "myFriendsCell", for: indexPath) as! PlaylistTableViewCell
        //해당 플레이리스트 이름을 라벨에 적음
        cell.playlistName.text = currentUser.playlists[indexPath.row].playlistName
        //해당 플레이리스트의 이미지를 불러온다.
        cell.playlistImage.image = UIImage(named: "record-\( currentUser.playlists[indexPath.row].playlistImageString)")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toPlaylist" else {
            return
        }
        guard let sendingPlaylist = sender as? Playlist else {
            return
        }
        guard let destination = segue.destination as? PlaylistSongListViewController else {
            return
        }
        //플레이리스트 내부 뷰에 플레이리스트 전송
        destination.source = sendingPlaylist
        //플레이리스트 내부 뷰에 플레이리스트 주인 정보 전송
        destination.currentUser = currentUser
    }
    
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
                        //플레이리스트 이미지 string 저장
                        temPlaylist.playlistImageString = data["playlistImageString"] as! String
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
                            self.userPlaylistsTableView.reloadData()
                        }
                    }
                }
            }
    }



//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        userPlaylistsTableView.deselectRow(at: indexPath, animated: true)
//    }
}
