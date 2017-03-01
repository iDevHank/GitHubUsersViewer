//
//  UIAlertViewController+ErrorMessage.swift
//  GitHubUsersViewer
//
//  Created by Hank on 15/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(error: APIClientError, handler: ((UIAlertAction) -> Void)? = nil) {
        var message: String
        switch error {
        case .network:
            message = "GitHub can’t be reached.\nPlease check your network."
        case .server:
            message = "An internal server error occurred."
        case .unknown:
            message = "An unexpected error occurred.\nPlease try it later."
        }
        self.init(title: "Oops!", message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction.init(title: "OK", style: .default, handler: handler))
    }
}
