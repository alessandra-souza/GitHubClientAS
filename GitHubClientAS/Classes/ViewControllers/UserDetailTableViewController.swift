//
//  UserDetailTableViewController.swift
//  GitHubClientAG
//
//  Created by Alexandre Giguere on 2019-11-27.
//  Copyright © 2019 Beyond Technologies. All rights reserved.
//

import UIKit

class UserDetailTableViewController: UITableViewController {

    var user: BeyondUser!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - Internal API
extension UserDetailTableViewController {
    
    static func createInstanceFromStoryboard(user: BeyondUser) -> UserDetailTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(identifier: "UserDetail") as! UserDetailTableViewController
        viewController.user = user
        
        return viewController
    }
}
