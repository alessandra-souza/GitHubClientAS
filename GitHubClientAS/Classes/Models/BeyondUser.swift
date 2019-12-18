//
//  BeyondUser.swift
//  GitHubClientAG
//
//  Created by Alexandre Giguere on 2019-10-24.
//  Copyright © 2019 Beyond Technologies. All rights reserved.
//

import Foundation

struct BeyondUser: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let gitHubUser: String
    let team: String
    let imageName: String
}

extension BeyondUser {
    var name: String { "\(firstName) \(lastName)" }
    
    static func getUsersFromPropertyList() -> [BeyondUser]? {
        guard let url = Bundle.main.url(forResource: "BeyondUsers", withExtension: "plist") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            
            let users = try PropertyListDecoder().decode([BeyondUser].self, from: data)
            
            return users
            
        } catch {
            return nil
        }
    }
}
