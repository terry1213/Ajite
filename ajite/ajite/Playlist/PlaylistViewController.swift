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
        self.playlistTableView.delegate = self

    }
    
    //adding to array of playlist classes
    
    @IBAction func plusTapped(_ sender: Any) {
        let alert = UIAlertController (title: "New Playlist", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (playlistTextField) in
            playlistTextField.placeholder = "Enter Playlist Name"
        })
        let action = UIAlertAction(title: "Add", style: .default){(_) in guard let newPlaylist = alert.textFields?.first?.text else{return}
            
            if newPlaylist.trimmingCharacters(in: .whitespaces).isEmpty{
                         let nameIsEmpty = UIAlertController(title: "Empty Name Field", message: "Your Playlist must have a name.", preferredStyle: .alert)
                         
                         nameIsEmpty.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                    NSLog("The \"OK\" alert occured.")}))
                                    
                                 self.present(nameIsEmpty, animated: true, completion: nil)
                                    return
                }
            
            let playlistToAdd = Playlist()
            playlistToAdd.playlistName = newPlaylist
            let song1 = Song()
            song1.name = "Palette - IU"
            song1.artist = "IU"
            playlistToAdd.songs.append(song1)
            let song2 = Song()
            song2.name = "Jenga - Heize"
            song2.artist = "Heize"
            playlistToAdd.songs.append(song2)
            
            let random = arc4random_uniform(4)
            let imageName = "playlist-\(random)"
        
            playlistToAdd.playlistImage = UIImage(named: imageName)!
            playlists.append(playlistToAdd)
            self.playlistTableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)
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
        cell.playlistImage.image = playlists[indexPath.row].playlistImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 96
         }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        let deleteAlert = UIAlertController (title: "Delete Playlist", message: "Would you like to delete your playlist?" ,preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
            
            guard editingStyle == .delete else { return }
            playlists.remove(at: indexPath.row)
            self.playlistTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
       
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = playlists[fromIndexPath.row]
           playlists.remove(at: fromIndexPath.row)
            playlists.insert(movedObject, at: to.row)
        }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
}

extension PlaylistViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dataToSend = playlists[indexPath.row]
    self.performSegue(withIdentifier: "toPlaylist", sender: dataToSend)
    }
}
