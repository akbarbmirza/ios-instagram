//
//  LoginViewController.swift
//  Gramr
//
//  Created by Akbar Mirza on 3/6/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        if let username = usernameField.text {
            newUser.username = username
        }
        
        if let password = passwordField.text {
            newUser.password = password
        }
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                
            } else {
                print("SUCCESS: \(newUser.username!) registered")
                
                // manually segue to logged in view
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username,
                                 password: password) { (user: PFUser?, error: Error?) in
                                    
                                    if let error = error {
                                        print("User Login Failed")
                                        print("ERROR: \(error.localizedDescription)")
                                    } else {
                                        if let user = user {
                                            print("SUCCESS: \(user.username!) Logged In Succesfully")
                                        }
                                        
                                        // display the view controller that needs to show after succesful login
                                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                    }
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
