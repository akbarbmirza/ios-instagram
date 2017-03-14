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

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    var photo: UIImage?
    var posts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openCamera(action: UIAlertAction?) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        vc.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func openLibrary(action: UIAlertAction?) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func loadData() {
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        print(query)
        
        // Look Through Parse
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                print("SUCCESS: Got Posts!")
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print("ERROR: Couldn't get posts!")
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func onCamera(_ sender: UIBarButtonItem) {
        
        // check if camera is available
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if isCameraAvailable {
            let ac = UIAlertController(title: "Take Photos from Camera or Library",
                                       message: nil,
                                       preferredStyle: .actionSheet)
            // add Camera option
            ac.addAction(UIAlertAction(title: "Camera",
                                       style: .default,
                                       handler: openCamera))
            
            // add Photo Library option
            ac.addAction(UIAlertAction(title: "Photo Library",
                                       style: .default,
                                       handler: openLibrary))
            
            // add Cancel
            ac.addAction(UIAlertAction(title: "Cancel",
                                       style: .cancel))
            
            // Show Action Controller
            present(ac, animated: true)
            
        } else {
            openLibrary(action: nil)
        }
        
    }
    
    @IBAction func onSignOut(_ sender: UIBarButtonItem) {
        
        PFUser.logOutInBackground { (error: Error?) in
            // PFUser.currentUser() will now be nil
            
            NotificationCenter.default.post(name: User.logOutNotification.name, object: nil)
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "onCamera" {
            
            if let photo = photo {
                let destinationVC = segue.destination as! AddPhotoTableViewController
                
                destinationVC.photo = photo
            }
            
        }
        
    }

}

// implement UIImagePickerController Delegate
extension TimelineViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // get the image captured by the UIImagePickerController
        if let possibleImage = info[UIImagePickerControllerOriginalImage] as! UIImage? {
            
            let resizedOriginal = resize(image: possibleImage,
                                         newSize: CGSize(width: 500, height: 500))
            
            self.photo = resizedOriginal
            
            
        }
        
//        else if let possibleImage = info[UIImagePickerControllerEditedImage] as! UIImage? {
//            
//            let resizedEdited = resize(image: possibleImage,
//                                         newSize: CGSize(width: 1280, height: 720))
//            
//            self.photo = resizedEdited
//
//            
//        }
        
        else {
            return
        }
        
        // dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
        // performSegue
        self.performSegue(withIdentifier: "onCamera", sender: Any?.self)
    }
}

// implement UINavigationController Delegate
extension TimelineViewController: UINavigationControllerDelegate {
    
}

// implement tableView Methods
extension TimelineViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts?[indexPath.row]
        
        cell.post = post
        
        return cell
    }
    
}

extension TimelineViewController: UITableViewDelegate {
    
}
