//
//  File.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//


import Foundation
import UIKit

class User : Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.userID == rhs.userID
    }
    
    var name = String()
    var friends = [User]()
    var userID = String()
    var bio = String()
    
}


class Ajite {
    var name = String ()
    var members = [User]()
    var sharedSongs = [Song]()
    var ajiteID = String()
    var ajiteImageString = String()
    init () {
        name = ""
    }
}

class Playlist {
    var playlistName = String()
    var songs = [Song]()
    var playlistImageString = String()
    init (){
        playlistName = ""
    }
}

class Song {
    var name : String
    var artist : String
    var videoID : String
    init(){
        name = ""
        videoID = ""
        artist = ""
    }
}
