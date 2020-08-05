//
//  File.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//


import Foundation
import UIKit

class User{
    var name = String()
    var friends = [User]()
    var sharedSongs = [Song]()
    var userID = String()
    
}


class Ajite {
    var name = String ()
    var numberOfMembers = Int()
    var members = [User]()
    var sharedSongs = [Song]()
    var imageName = String()
    init () {
        name = ""
        numberOfMembers = members.count
    }
}

class Playlist {
    var playlistName = String()
    var songs = [Song]()
    let ajiteOrPersonal : Bool
    init (){
        playlistName = ""
        ajiteOrPersonal = true
    }
}

class Song {
    let name : String
    let artist : String
    let videoID : String
    init(){
        name = ""
        videoID = ""
        artist = ""
    }
}
