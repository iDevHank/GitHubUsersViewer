//
//  UserDetailsViewController.swift
//  GitHubUsersViewer
//
//  Created by Hank on 14/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import UIKit
import Alamofire

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingsLabel: UILabel!

    fileprivate var indicator: UIActivityIndicatorView!
    fileprivate var userName: String!
    fileprivate var request: Alamofire.Request?
    fileprivate var user: UserDetail? {
        didSet {
            updateViews()
        }
    }

    init(userName: String) {
        super.init(nibName: "UserDetailsViewController", bundle: nil)
        self.userName = userName
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        request?.cancel()
    }

}

// MARK: Logic
extension UserDetailsViewController {

    fileprivate func loadData() {
        request = APIClient.getUserDetails(userName: userName,
                                           success: { jsonData in
                                            self.indicator.stopAnimating()
                                            guard let user = UserDetail(json: jsonData) else {
                                                let alertController = UIAlertController(error: .server, handler: { _ in
                                                    _ = self.navigationController?.popViewController(animated: true)
                                                })
                                                self.present(alertController, animated: true, completion: nil)
                                                return
                                            }
                                            self.user = user
        },
                                           failure: { error in
                                            self.indicator.stopAnimating()
                                            let alertController = UIAlertController(error: error, handler: { _ in
                                                _ = self.navigationController?.popViewController(animated: true)
                                            })
                                            self.present(alertController, animated: true, completion: nil)
        })
    }

    fileprivate func setupViews() {
        title = "Detail"
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
    }

    fileprivate func updateViews() {
        guard let user = user else {
            return
        }
        nameLabel.text = user.userName
        companyLabel.text = user.companyName
        publicReposLabel.text = user.publicRepos.description
        followersLabel.text = user.followers.description
        followingsLabel.text = user.followings.description
    }

}
