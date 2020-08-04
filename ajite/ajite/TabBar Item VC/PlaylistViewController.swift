//
//  PlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

var playlists = [Playlist]()

class PlaylistViewController: UIViewController,playlistDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
    
    }
    
    func addToPlaylist(name : String){
        let newPlaylist = Playlist()
        newPlaylist.playlistName = name
        playlists.append(newPlaylist)
        print(playlists)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "newplaylist"{
            let secondVC : NewPlaylistViewController = segue.destination as! NewPlaylistViewController
            secondVC.delegate = self
        }
    }

}



