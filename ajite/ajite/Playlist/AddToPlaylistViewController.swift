//
//  InsidePlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddToPlaylistViewController: UIViewController, UITableViewDelegate {
    
    var addingSong = Song()
    var addOrNot : [Bool] = []
    @IBOutlet weak var newPlaylist: UIView!
    @IBOutlet weak var playlistView: UITableView!
    var listVC: PlaylistSongListViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistView.dataSource = self
        self.playlistView.delegate = self
        //어떤 플레이리스트에 담을 것인지를 bool 값으로 표현, 플레이리스트의 개수만큼 array에 담고 있다.
        addOrNot = Array(repeating: false, count: myUser.playlists.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.playlistView.reloadData()
    }
    
    @IBAction func finished(_ sender: Any) {
        //어떤 플레이리스트에 담을 것인지 알기 위해 bool array를 확인한다.
        for index in 0 ..< addOrNot.count {
            //true = 담기
            if addOrNot[index] == true {
                //해당 플레이리스트 document에 추가하려는 노래 document를 생성한다.
                db
                    .collection("users").document(myUser.documentID)
                    .collection("playlists").document(myUser.playlists[index].id)
                    .collection("songs").addDocument(data:[
                        "name" : addingSong.name,
                        "artist" : addingSong.artist,
                        "thumbnailImageUrl" : addingSong.thumbnailImageUrl,
                        "videoID" : addingSong.videoID
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Song successfully added to playlist")
                        }
                    }
                //해당 플레이리스트 document의 songNum field를 1 늘려준다.
                db
                    .collection("users").document(myUser.documentID)
                    .collection("playlists").document(myUser.playlists[index].id).updateData([
                        "songNum" : FieldValue.increment(Int64(1))
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("SongNum successfully updated")
                        }
                    }
            }
        }
        //해당 플레이리스트 창으로 돌아가기 전에 노래 리스트를 다시 불러온다.
        listVC?.getData()
        dismiss(animated: true)
    }
}

extension AddToPlaylistViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
             return 1
         }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistView.dequeueReusableCell(withIdentifier: "addToPlaylist", for: indexPath) as! AddToPlaylistTableViewCell
        //Label에 플레이리스트 이름을 적는다.
        cell.playlistName.text = myUser.playlists[indexPath.row].playlistName
        cell.cellDelegate = self
        //해당 셀의 인덱스를 저장한다.
        cell.index = indexPath
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension AddToPlaylistViewController: AddToPlaylistProtocol{
    //플레이리스트가 체크되었기 때문에 해당 셀의 인덱스에 맞는 bool 값을 true로 만들어준다.
    func checkPlaylist(index: Int) {
        addOrNot[index] = true
    }
    //플레이리스트가 체크 해제되었기 때문에 해당 셀의 인덱스에 맞는 bool 값을 false로 만들어준다.
    func uncheckPlaylist(index: Int) {
        addOrNot[index] = false
    }
}
