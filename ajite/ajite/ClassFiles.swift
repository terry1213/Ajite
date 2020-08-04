//
//  File.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//


import Foundation


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
    
    init (){
        playlistName = ""
        numberOfSongs = 0
    }
}
