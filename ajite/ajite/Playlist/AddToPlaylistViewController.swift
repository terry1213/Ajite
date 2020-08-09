//
//  InsidePlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/02.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class AddToPlaylistViewController: UIViewController, UITableViewDelegate {
    
    var addingSong = Song()
    var addOrNot : [Bool] = []
    @IBOutlet weak var newPlaylist: UIView!
    @IBOutlet weak var playlistView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistView.dataSource = self
        self.playlistView.delegate = self
        addOrNot = Array(repeating: false, count: playlists.count)
        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
        self.playlistView.reloadData()
    }
        
    @IBAction func finished(_ sender: Any) {
        for index in 0 ..< addOrNot.count {
            if addOrNot[index] == true {
                db
                    .collection("users").document(myUser.documentID)
                    .collection("playlists").document(playlists[index].id)
                    .collection("songs").addDocument(data:[
                        "name" : addingSong.name,
                        "artist" : addingSong.artist,
                        "thumbnailImageUrl" : addingSong.thumbnailImageUrl,
                        "videoID" : addingSong.videoID
                    ])
            }
        }
        dismiss(animated: true)
    }
}

extension AddToPlaylistViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
             return 1
         }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistView.dequeueReusableCell(withIdentifier: "addToPlaylist", for: indexPath) as! AddToPlaylistTableViewCell
        cell.playlistName.text = playlists[indexPath.row].playlistName
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt
     indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension AddToPlaylistViewController: AddToPlaylistProtocol{
    func checkPlaylist(index: Int) {
        addOrNot[index] = true
    }
    
    func uncheckPlaylist(index: Int) {
        addOrNot[index] = false
    }
}
