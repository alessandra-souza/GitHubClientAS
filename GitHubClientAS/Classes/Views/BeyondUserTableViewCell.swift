//
//  BeyondUserTableViewCell.swift
//  GitHubClientAG
//
//  Created by Alexandre Giguere on 2019-10-29.
//  Copyright © 2019 Beyond Technologies. All rights reserved.
//

import UIKit

class BeyondUserTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var faceImageView: UIImageView!
    
    var user: BeyondUser? {
        didSet {
            guard let user = user else { return }
            
            nameLabel.text = user.name
            emailLabel.text = user.email
            faceImageView.image = UIImage(named: user.imageName)
            faceImageView.layer.cornerRadius = faceImageView.frame.size.width / 2
        }
    }
}
