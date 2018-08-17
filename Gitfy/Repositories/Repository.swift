//
//  Repository.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/2/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation

class Repository {
    var description: String?
    var issues, forks, watchers, stargazers: Int
    var name, created: String
    init(_ name: String, _ description: String?, _ created: String, _ issues: Int, _ forks: Int, _ watchers: Int, _ stargazers: Int){
        self.name = name
        self.description = description
        self.created = created
        self.issues = issues
        self.forks = forks
        self.watchers = watchers
        self.stargazers = stargazers
    }
}
