//
//  ViewController.swift
//  GitHubUsersViewer
//
//  Created by Hank on 14/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import UIKit

private struct UsersCollectionViewConstants {
    static let nibName = "UserCollectionViewCell"
    static let cellIdentifier = "kUsersCollectionViewCell"
    static let cellSpacing: CGFloat = 25.0
    static let labelHeight: CGFloat = 30.0
}

class UsersViewController: UIViewController {

    fileprivate var collectionView: UICollectionView!
    fileprivate var indicator: UIActivityIndicatorView!
    fileprivate var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }

}

// MARK: Logic
extension UsersViewController {

    fileprivate func setupViews() {
        title = "GitHub Users"

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (view.bounds.size.width - 3 * UsersCollectionViewConstants.cellSpacing) / 2.0
        layout.itemSize = CGSize(width: width, height: width + UsersCollectionViewConstants.labelHeight)
        layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: UsersCollectionViewConstants.nibName, bundle: nil),
                                forCellWithReuseIdentifier: UsersCollectionViewConstants.cellIdentifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.loadData()
        })

        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
    }

    fileprivate func loadData() {
        APIClient.getUsers(since: users.last?.id.description,
                           success: { jsonData in
                            self.resetStatus()
                            let newData = User.users(jsonArray: jsonData)
                            self.users.append(contentsOf: newData)
                            self.collectionView.reloadData()
        },
                           failure: { error in
                            self.resetStatus()
                            let alertController = UIAlertController(error: error)
                            self.present(alertController, animated: true, completion: nil)
        })
    }

    private func resetStatus() {
        self.indicator.stopAnimating()
        self.collectionView.mj_footer.endRefreshing()
    }

}

// MARK: UICollectionViewDataSource
extension UsersViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersCollectionViewConstants.cellIdentifier, for: indexPath) as! UserCollectionViewCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

}

// MARK: UserCollectionViewCellDelegate
extension UsersViewController: UserCollectionViewCellDelegate {

    func didTapAvatar(name: String) {
        let detailVC = UserDetailsViewController(userName: name)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
