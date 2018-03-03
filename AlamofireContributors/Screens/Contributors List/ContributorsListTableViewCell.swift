//
//  ContributorsListTableViewCell.swift
//  AlamofireContributors
//
//  Created by Vasyl Skrypij on 3/1/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import UIKit

class ContributorsListTableViewCell: UITableViewCell {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var contributionsLabel: UILabel!
    @IBOutlet weak var avatar: NetworkImageView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatar.layer.cornerRadius = 10.0;
        self.avatar.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UI methods
    
    func updateCellForUser(_ user: User) {
        loginLabel.text = user.login
        contributionsLabel.text = "Contributions: \(user.contributions ?? 0)"
        avatar.loadImageUsingCache(withUrl: user.avatarURL)
    }

}
