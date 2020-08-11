//
//  notificationViewController.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/11.
//  Copyright © 2020 ajite. All rights reserved.
//

import Foundation
import UIKit

class notificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userRef = db.collection("users")
    var displayUsers: [User] = []
    var displayAjites: [Ajite] = []
    
    func getInvitationData(){
        db
        .collection("users").document(myUser.documentID).collection("invitation" ).getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    
                    print(myUser.documentID)
                                    let ajiteName = data["ajiteName"] as? String
                                    let temAjite = Ajite()
                                    temAjite.name = ajiteName!
                                    self.displayAjites.append(temAjite)
                                    print(temAjite.name)
                                }
                            }
            self.notificationTV.reloadData()
            }
        }
    
        
    
    
    @IBOutlet var notificationTV: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayAjites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTV.dequeueReusableCell(withIdentifier: "notificationCell") as! notificationCell
        cell.ajiteName.text = displayAjites[indexPath.row].name
        return cell
    }
    override func viewDidLoad() {
        displayAjites.removeAll()
        super.viewDidLoad()
        getInvitationData()
        notificationTV.delegate = self
        notificationTV.dataSource = self
    }
    
}
