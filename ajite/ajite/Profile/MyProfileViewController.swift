//
//  MyProfileViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var playlist: UITableView!
    @IBOutlet weak var playlistSearch: UISearchBar!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlist.dataSource = self
        self.playlist.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //플레이리스트 데이터 불러오기
        getPlaylistsData() {
            //테이블에 불러온 정보를 보여준다.
            self.playlist.reloadData()
        }
        //Label에 이름 적기
        self.userName.text = myUser.name
        //Label에 biography 적기
        getUserBio(){}
        //UIImage에 유저 프로필 사진 넣기
        let data = try? Data(contentsOf: URL(string: myUser.profileImageURL)!)
        self.profileImage.image = UIImage(data: data!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toPlaylist" else {
            return
        }
        guard let sendingPlaylist = sender as? Playlist else {
            return
        }
        guard let destination = segue.destination as? PlaylistViewController else {
            return
        }
        //플레이리스트 내부 뷰에 플레이리스트 전송
        destination.playlist = sendingPlaylist
        //플레이리스트 내부 뷰에 플레이리스트 주인 정보 전달
        destination.currentUser = myUser
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func getUserBio(completion: @escaping () -> Void){
        //유저 정보 불러오기
        db
            .collection("users").document(myUser.documentID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                myUser.bio = document.data()!["bio"] == nil ? "" : document.data()!["bio"] as! String
                self.bio.text = myUser.bio
                print("Current data: \(data)")
                completion()
            }
    }
    
    func getPlaylistsData(completion: @escaping () -> Void){
        db
            .collection("users").document(myUser.documentID)
            .collection("playlists").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    //우선 전에 받아왔던 플레이리스트 정보들을 다 삭제한다.
                    myUser.playlists.removeAll()
                    //정보를 받아오기 위한 임시 플레이리스트 선언
                    var temPlaylist: Playlist
                    //firestore에서 본인의 플레이리스트를 전부 불러와서 하나하나씩 처리한다.
                    for document in querySnapshot!.documents {
                        //다음 플레이리스트를 담기 위한 임시 플레이리스트 생성
                        temPlaylist = Playlist()
                        //플레이리스트 이름 받기
                        temPlaylist.playlistName = document.data()["name"] as! String
                        //플레이리스트 아이디 받기
                        temPlaylist.songNum = document.data()["songNum"] as! Int
                        temPlaylist.id = document.documentID
                        //플레이리스트 목록에 추가
                        myUser.playlists.append(temPlaylist)
                    }
                    print("The number of playlists is \(myUser.playlists.count)")
                    completion()
                }
            }
    }
    
    // ==================================================================>
    
}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlist.dequeueReusableCell(withIdentifier: "PlaylistTableViewCell", for: indexPath) as! PlaylistTableViewCell
        //해당 플레이리스트 이름을 라벨에 적음
        cell.playlistName.text = myUser.playlists[indexPath.row].playlistName
        //해당 플레이리스트에 속한 노래의 개수를 적음
        cell.numberOfSongs.text = "\(myUser.playlists[indexPath.row].songNum) songs"
        cell.record.image = UIImage(named:"레코드판")
        cell.layer.masksToBounds = true
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //전송할 플레이리스트 할당
        let dataToSend = myUser.playlists[indexPath.row]
        //플레이리스트 내부 뷰로 이동
        self.performSegue(withIdentifier: "toPlaylist", sender: dataToSend)
    }
}
