//
//  FriendProfileViewController.swift
//  ajite
//
//  Created by 임연우 on 2020/08/11.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var playlistNumLabel: UILabel!
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
        self.userNameLabel.text = currentUser.name
        self.bio.text = currentUser.bio
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
        //해당 플레이리스트에 속한 노래의 개수를 적음
        //cell.numberOfSongsInPlaylist.text = "\(currentUser.playlists[indexPath.row].songNum) songs"
        //해당 플레이리스트의 이미지를 불러온다.
        cell.playlistImage.image = UIImage(named: "record-\( currentUser.playlists[indexPath.row].playlistImageString)")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToSend = currentUser.playlists[indexPath.row]
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
        destination.source = sendingPlaylist
        destination.currentUser = currentUser
    }

    func getData(){
        db
            .collection("users").document(currentUser.documentID)
            .collection("playlists").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.currentUser.playlists.removeAll()
                    self.playlistNumLabel.text = "(\(querySnapshot!.documents.count))"
                    var temPlaylist : Playlist
                    var count = 0
                    for document in querySnapshot!.documents {
                        temPlaylist = Playlist()
                        let data = document.data()
                        temPlaylist.playlistName = data["name"] as! String
                        temPlaylist.playlistImageString = data["playlistImageString"] as! String
                        temPlaylist.songNum = data["songNum"] as! Int
                        temPlaylist.id = document.documentID
                        self.currentUser.playlists.append(temPlaylist)
                        count += 1
                        if count == querySnapshot!.documents.count {
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
