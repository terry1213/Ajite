//
//  CreateAjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class MemberCell : UITableViewCell{
    
    @IBOutlet weak var profilepicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
          // Initialization code
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
    }
   
    
    
}

class CreateAjiteViewController: UIViewController {

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    //@IBAction func unwindToRed(unwindSegue: UIStoryboardSegue) {
   // }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
