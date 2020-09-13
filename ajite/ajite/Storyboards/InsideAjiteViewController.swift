//
//  InsideAjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/13.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class InsideAjiteViewController: UIViewController {
    
    let youtubePlayerViewController = YoutubePlayerViewController()
       var currentAjite = Ajite()
       var nextSourceIndex : Int = -1
    
    
    @IBOutlet weak var ajiteName: UILabel!
    @IBOutlet weak var ajiteInfo: UILabel!
    @IBOutlet weak var sharedSongsTable: UITableView!
    
    
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var channelName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
