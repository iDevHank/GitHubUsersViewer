//
//  UserDetail.swift
//  GitHubUsersViewer
//
//  Created by Hank on 15/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserDetail {

    let userName: String?
    let companyName: String?
    let publicRepos: Int
    let followers: Int
    let followings: Int

    init?(json: JSON) {
        guard let publicRepos = json["public_repos"].int,
            let followers = json["followers"].int,
            let followings = json["following"].int else {
                return nil
        }
        self.userName = json["name"].string
        self.companyName = json["company"].string
        self.publicRepos = publicRepos
        self.followers = followers
        self.followings = followings
    }

}
