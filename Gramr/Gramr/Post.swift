//
//  Post.swift
//  Gramr
//
//  Created by Akbar Mirza on 3/11/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    /**
     * Other Methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants to upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?,
                             withCaption caption: String?,
                             withCompletion completion: PFBooleanResultBlock?) {
        
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        let caption = caption ?? "Check This Out!"
        post["caption"] = caption
        post["media"] = getPFFileFromImage(image: image) // PFFile Column Type
        post["author"] = PFUser.current() // Pointer column type that points to PFUser
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        
        // check if image is not nil
        if image != nil {
            
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image!) {
                print("SUCCESS: CONVERT TO PFF")
                return PFFile(name: "image.png", data: imageData)
            }
        }
        
        print("ERROR: COULD NOT CONVERT TO PFF")
        return nil
        
    }
}
