//
//  PostCell.swift
//  Gramr
//
//  Created by Akbar Mirza on 3/13/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import ParseUI

class PostCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    // Variables
    var post: PFObject! {
        
        didSet {
            
            // set username
            let user = post["author"] as! PFUser
            self.usernameLabel.text = user.username
            
            // set caption
            if let caption = post["caption"] as! String? {
                self.captionLabel.text = caption
            }
            
            // load image to PFView
            if let imageFile = post["media"] as? PFFile {
                imageFile.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if let data = data {
                        self.photoImageView.image = UIImage.init(data: data)
                    }
                })
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.avatarImageView.image =
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
