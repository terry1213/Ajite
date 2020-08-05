//
//  PlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

var playlists : [Playlist] = []

class PlaylistViewController: UIViewController{
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
        self.playlistTableView.dataSource = self

    }
    //adding to array of playlist classes
    
    @IBAction func plusTapped(_ sender: Any) {
        let alert = UIAlertController (title: "New Playlist", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (playlistTextField) in
            playlistTextField.placeholder = "Enter Playlist Name"
        })
        let action = UIAlertAction(title: "Add", style: .default){(_) in guard let newPlaylist = alert.textFields?.first?.text else{return}
            
            
            let playlistToAdd = Playlist()
            playlistToAdd.playlistName = newPlaylist
            playlists.append(playlistToAdd)
            self.playlistTableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    

}

extension PlaylistViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistTableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        cell.playlistName.text = playlists[indexPath.row].playlistName
        //cell.ownerLabel.text = "\(playlists[indexPath.row].ownerName), \(playlists[indexPath.row].songs.count)"
        cell.numberOfSongsInPlaylist.text = " \(playlists[indexPath.row].songs.count) songs"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 96
         }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        playlists.remove(at: indexPath.row)
        playlistTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
