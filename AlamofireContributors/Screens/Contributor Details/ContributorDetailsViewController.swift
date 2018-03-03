//
//  ContributorDetailsViewController.swift
//  AlamofireContributors
//
//  Created by Vasyl Skrypij on 3/1/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import UIKit

class ContributorDetailsViewController: UIViewController {
   
    var login : String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    @IBOutlet weak var avatar: NetworkImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard (login != nil) else {
            return
        }
        
        self.title = login

        APIManager.sharedInstance.userInfo(login: login!) { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            switch result {
            case .success(let user):
                self.avatar.loadImageUsingCache(withUrl: user.avatarURL)
                self.nameLabel.text = "Name: \(user.login)"
                self.companyLabel.text = "Company: \(user.company ?? "")"
                self.locationLabel.text = "Location: \(user.location ?? "")"
                self.publicReposLabel.text = "Public repositories: \(user.publicRepos ?? 0)"
                
                self.avatar.layer.cornerRadius = 20.0;
                self.avatar.layer.masksToBounds = true;
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
