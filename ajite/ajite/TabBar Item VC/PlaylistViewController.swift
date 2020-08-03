//
//  PlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//
struct Playlist{
    var playlistName = String()
    var numberOfSongs = Int()
    
    init (){
        playlistName = ""
        numberOfSongs = 0
    }
}

import UIKit



class PlaylistViewController: UIViewController,playlistDelegate {
    
    
     var playlists = [Playlist]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
    
    }
    
    func addToPlaylist(name : String){
        var playlist = Playlist()
        playlist.playlistName = name
        playlists.append(playlist)
        print(playlists)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "newplaylist"{
            let secondVC : NewPlaylistViewController = segue.destination as! NewPlaylistViewController
            secondVC.delegate = self
        }
    }

}



