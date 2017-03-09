//
//  TimelineViewController.swift
//  Gramr
//
//  Created by Akbar Mirza on 3/8/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSignOut(_ sender: UIBarButtonItem) {
        
        PFUser.logOutInBackground { (error: Error?) in
            // PFUser.currentUser() will now be nil
            
            NotificationCenter.default.post(name: User.logOutNotification.name, object: nil)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
