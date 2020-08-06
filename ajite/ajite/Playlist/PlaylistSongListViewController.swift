//
//  PlaylistSongListViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/03.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class PlaylistSongListViewController: UIViewController {
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
        self.songListTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .none
       }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    @IBAction func pressedPlus(_ sender: Any) {
       performSegue(withIdentifier: "addToPlaylistSegue", sender: self)
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
    cell.songName.text = source.songs[indexPath.row].name
    cell.artistName.text = source.songs[indexPath.row].artist
    return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 60
         }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          guard editingStyle == .delete else { return }
          
          source.songs.remove(at: indexPath.row)
          songListTableView.deleteRows(at: [indexPath], with: .automatic)
      }
}
