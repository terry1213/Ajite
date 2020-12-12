//
//  PlaylistTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var record: UIImageView!
    @IBOutlet weak var youtube: UIImageView!
    @IBOutlet weak var numberOfSongs: UILabel!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var lock: UIButton!
    
    var playlistID: String!
    var isPrivate: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func touchPrivatePublicChangeButton(_ sender: Any) {
        isPrivate = !isPrivate
        db.collection("users")
            .document(myUser.documentID)
            .collection("playlists")
            .document(playlistID)
            .updateData([
                "isPrivate": isPrivate as Any,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
    }
}
