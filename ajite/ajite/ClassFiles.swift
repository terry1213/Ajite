//
//  File.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//


import Foundation
import UIKit

class Member {
    var name = String()
      var userID = String ()
      
      init(){
          name = ""
          userID = ""
      }
}


class Ajite {
    var name = String ()
    var numberOfMembers = Int()
    var members = [Member]()
    init () {
        name = ""
        numberOfMembers = 0
    }
}

class Playlist {
    var playlistName = String()
    var numberOfSongs = Int()
    var songs = [Song]()
    let ajiteOrPersonal : Bool
    init (){
        playlistName = ""
        numberOfSongs = 0
        ajiteOrPersonal = true
    }
}

class Song {
    let name : String
    let artist : String
    let link : String
    var thumbnail = UIImage()
    init(){
        name = ""
        link = ""
        artist = ""
    }
}
