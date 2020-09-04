//
//  notificationViewController.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/11.
//  Copyright © 2020 ajite. All rights reserved.
//

import Foundation
import UIKit

class NotificationViewController: UIViewController {
    
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
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium

        return formatter.string(from: date as Date)
    }
    // ==================================================================>
    
}

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayAjites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTV.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationCell
        cell.ajiteName.text = displayAjites[indexPath.row].name
       //!!!! cell.초대자.text = "by \(displayAjites[indexPath.row].creator.name)"
        //!!!!cell.timeInvited.text = displayAjites[indexPath.row].timestamp.calendarTimeSinceNow()
        // let data = try? Data(contentsOf: URL(string: displayAjites[indexPath.row].creator.profileImageURL)!)
        //!!!!  cell.초대자profile.image = UIImage(named: data!)
        return cell
    }
    
}

extension NotificationViewController: UITableViewDelegate {
    
}

/*extension Date{
    func calendarTimeSinceNow() ->String
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours =  components.hour!
        let minutes = components.minute!
        
        if years > 0{
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        else if months > 0{
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }
        else if hours > 0{
            return hours == 1 ? "1 hour ago" : "\(hours) ago"
        }
        else if minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) ago"
        }
        else {
            return " a few seconds ago"
        }
    }
}*/


