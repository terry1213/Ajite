//
//  StructFiles.h
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//

#ifndef StructFiles_h
#define StructFiles_h

struct Ajite{
    var name = String ()
    var numberOfMembers = Int()
    var members = [Member]()
    
    init(){
        name = ""
        numberOfMembers = 0
    }
}


struct Member {
    var name = String()
    var userID = String ()
    
    init(){
        name = ""
        userID = ""
    }
}

#endif /* StructFiles_h */
