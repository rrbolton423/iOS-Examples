//
//  ViewController.swift
//  Codable
//
//  Created by Romell Bolton on 12/15/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

struct MyGitHub: Codable { // Conform to "Codable" protocol
    
    // Define struct properties
    let name: String?
    let location: String?
    let followers: Int?
    let avatarUrl: URL?
    let repos: Int?
    
    // In order to solve camel case problem, we can declare Coding Keys enum and tell to use snake case for Swift constant and camel case for JSON.
    private enum CodingKeys: String, CodingKey {
        case name
        case location
        case followers
        case repos = "public_repos"
        case avatarUrl = "avatarUrl"
    }
}

class ViewController: UIViewController {
    
    // Define UI elements (IBOutlets)
    @IBOutlet weak var gitUname: UITextField!
    var imageUrl: URL?
    var newImage: UIImage?
    
    @IBOutlet weak var blog: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var gravatarImage: UIImageView!
    
    @IBOutlet weak var gname: UILabel!
    @IBOutlet weak var glocation: UILabel!
    @IBOutlet weak var grepos: UILabel!
    @IBOutlet weak var gfollowers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Hide all UI elements when the view loads
        setLabelStatus(value: true)
    }
    
    @IBAction func ShowGithubInfo(_ sender: Any) {
        
        // Get the username for Gtihub account
        let userText = gitUname.text?.lowercased()
        
        // Construct Github URL pointing to user account
        guard let gitUrl = URL(string: "https:api.github.com/users/" + userText!) else { return }
        
        // Create a URLSession instance, passing the url receiving back 'data, response, and an error'
        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
            
            // Error handle
            if error != nil { return }
            
            // Obtain the data if not nil, else return from the method
            guard let data = data else { return }
            
            // Try to...
            do {
                
                // Create an instance of JSONDecoder, which will decode the data into an instance that conforms to Codable
                let decoder = JSONDecoder()
                
                // Decode the json data into an instance of 'MyGitHub', which conforms to the Codable protocol
                let gitData = try decoder.decode(MyGitHub.self, from: data)
                
                // Go to the main thread to update UI
                DispatchQueue.main.async {
                    
                    // If the image is not nil
                    if let gimage = gitData.avatarUrl {
                        
                        // Create the image and set it in the UI
                        let data = try? Data(contentsOf: gimage)
                        let image: UIImage = UIImage(data: data!)!
                        self.gravatarImage.image = image
                    }
                    
                    // Unwrap data and populate UI
                    if let gname = gitData.name {
                        self.name.text = gname
                    }
                    if let glocation = gitData.location {
                        self.location.text = glocation
                    }
                    if let gfollowers = gitData.followers {
                        self.followers.text = String(gfollowers)
                    }
                    if let grepos = gitData.repos {
                        self.blog.text = String(grepos)
                    }
                    
                    // Unhide the UI after populating it
                    self.setLabelStatus(value: false)
                }
                
                // Catch error
            } catch let err {
                
                // Print error
                print("Err", err)
            }
        }.resume() // Resume the data task
    }
    
    // This method hides all UI elements
    func setLabelStatus(value: Bool) {
        name.isHidden = value
        location.isHidden = value
        followers.isHidden = value
        blog.isHidden = value
        gname.isHidden = value
        glocation.isHidden = value
        gfollowers.isHidden = value
        grepos.isHidden = value
    }

}

