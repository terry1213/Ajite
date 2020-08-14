//
//  notificationViewController.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/11.
//  Copyright © 2020 ajite. All rights reserved.
//

import Foundation
import UIKit

class notificationViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    let userRef = db.collection("users")
    var displayUsers: [User] = []
    var displayAjites: [Ajite] = []
    
    @IBOutlet var notificationTV: UITableView!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        displayAjites.removeAll()
        super.viewDidLoad()
        getInvitationData()
        notificationTV.delegate = self
        notificationTV.dataSource = self
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
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
    
    // ==================================================================>
    
}

extension notificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayAjites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTV.dequeueReusableCell(withIdentifier: "notificationCell") as! notificationCell
        cell.ajiteName.text = displayAjites[indexPath.row].name
        return cell
    }
    
}

extension notificationViewController: UITableViewDelegate {
    
}


