//
//  Structures.h
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//

#ifndef Structures_h
#define Structures_h


struct Playlist{
    var playlistName = String()
    var numberOfSongs = Int()
    
    init (){
        playlistName = ""
        numberOfSongs = 0
    }
}


struct Ajite{
    var name = String ()
    var numberOfMembers = Int()
    var members = [Member]()
}


struct Member {
    var name = String()
    var user
    
#endif /* Structures_h */
