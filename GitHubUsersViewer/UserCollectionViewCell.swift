//
//  UserTableViewCell.swift
//  GitHubUsersViewer
//
//  Created by Hank on 14/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import UIKit
import SDWebImage

protocol UserCollectionViewCellDelegate: class {
    func didTapAvatar(name: String)
}

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var user: User! {
        didSet {
            updateViews()
        }
    }
    weak var delegate: UserCollectionViewCellDelegate? = nil

    override func awakeFromNib() {
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        avatarImageView.addGestureRecognizer(tap)
    }

    private func updateViews() {
        avatarImageView.sd_setImage(with: URL(string: user.avatarURL)!, placeholderImage: UIImage(named: "github"))
        nameLabel.text = user.userName
    }

    @objc private func didTapImageView(gesture: UITapGestureRecognizer) {
        if let userName = nameLabel.text {
            delegate?.didTapAvatar(name: userName)
        }
    }

}
