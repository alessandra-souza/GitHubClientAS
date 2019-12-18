//
//  BeyondUsersViewModel.swift
//  GitHubClientAG
//
//  Created by Alexandre Giguere on 2019-11-03.
//  Copyright © 2019 Beyond Technologies. All rights reserved.
//

import Foundation

class BeyondUsersViewModel {
    
    private var users = BeyondUser.getUsersFromPropertyList()!
    private var initialUsers = BeyondUser.getUsersFromPropertyList()!
    
    var viewTitle: String { "Users" }
    
    var footerText: String {
        "\(users.count) users"
    }
    
    var numberOfSections: Int { 1 }

    func numberOfRowsInSection(_ section: Int) -> Int {
        users.count
    }
    
    func user(at indexPath: IndexPath) -> BeyondUser {
        users[indexPath.row]
    }
    
    func deleteUser(at indexPath: IndexPath) {
        users.remove(at: indexPath.row)
    }
    
    func moveUser(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedUser = users[sourceIndexPath.row]
        users.remove(at: sourceIndexPath.row)
        users.insert(movedUser, at: destinationIndexPath.row)
    }
    
    func refresh(completionHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.users = BeyondUser.getUsersFromPropertyList()!
            completionHandler()
        }
    }
    
    func filterUsersForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            users = initialUsers
        } else {
//            users = initialUsers.filter({ (user) -> Bool in
//                user.name.lowercased().contains(searchText.lowercased())
//            })
            
            users = initialUsers.filter( {$0.name.range(of: searchText, options: .caseInsensitive) != nil })
        }
    }
}
