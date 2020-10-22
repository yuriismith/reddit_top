//
//  Entry.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation
import UIKit

struct Entry {
    
    init(small: SmallEntry) {
        self.id = small.name
        self.title = small.title
        self.author = small.author
        self.date = Date(timeIntervalSince1970: TimeInterval(small.created))
        self.commentsCount = small.num_comments
        self.thumbnail = nil
        self.imageURL = URL(string: small.thumbnail)
    }
    
    var id: String
    var title: String
    var author: String
    var date: Date
    var commentsCount: Int
    var thumbnail: UIImage?
    var imageURL: URL?
}

extension Array where Element == Child {
    var entries: [Entry] {
        return self.map { Entry(small: $0.data) }
    }
}
