//
//  User.swift
//  GitHubUsersViewer
//
//  Created by Hank on 14/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {

    let id: Int
    let userName: String
    let avatarURL: String

    init?(json: JSON) {
        guard let id = json["id"].int,
            let userName = json["login"].string,
            let avatarURL = json["avatar_url"].string else {
                return nil
        }
        self.id = id
        self.userName = userName
        self.avatarURL = avatarURL
    }

    static func users(jsonArray: JSON) -> [User] {
        guard let jsonArray = jsonArray.array else {
            return []
        }
        var users: [User] = []
        for json in jsonArray {
            if let user = User(json: json) {
                users.append(user)
            }
        }
        return users
    }

}
