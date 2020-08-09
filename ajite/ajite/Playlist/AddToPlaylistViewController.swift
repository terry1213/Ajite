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
    @IBOutlet weak var newPlaylist: UIView!
    @IBOutlet weak var playlistView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistView.dataSource = self
        self.playlistView.delegate = self
        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
        self.playlistView.reloadData()
    }
        
    @IBAction func finished(_ sender: Any) {
        
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
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt
     indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
  
    
}
