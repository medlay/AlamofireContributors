//
//  UserEntity.swift
//  AlamofireContributors
//
//  Created by Vasyl Skrypij on 3/2/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import Foundation

struct User : Decodable {
    let login: String
    var contributions: Int?
    var avatarURL: URL
    var name: String?
    var company: String?
    var location: String?
    var publicRepos: Int?
    
    private enum CodingKeys: String, CodingKey {
        case login
        case contributions
        case avatarURL = "avatar_url"
        case name
        case company
        case location
        case publicRepos = "public_repos"
    }
}

