//
//  File.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//


import Foundation
import UIKit

class User {
    var name = String()
    var friends = [User]()
    var userID = String()
    var bio = String()
    var documentID = String()
    var request = String()
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
    var id = String()
    var playlistName = String()
    var songs = [Song]()
    var songNum = Int()
    var playlistImageString = String()
    init (){
        playlistName = ""
    }
}

class Song {
    var sharedPerson : String
    var name : String
    var artist : String
    var thumbnailImageUrl : String
    var videoID : String
    var songID : String
    init(){
        sharedPerson = ""
        name = ""
        artist = ""
        thumbnailImageUrl = ""
        videoID = ""
        songID = ""
    }
}
