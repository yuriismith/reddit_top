//
//  RedditTableViewCell.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import UIKit

class RedditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentsLable: UILabel!
    
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let reuseIdentifier = "RedditCell"
    
    static func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> RedditTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: RedditTableViewCell.reuseIdentifier, for: indexPath) as! RedditTableViewCell
    }
    
    weak var delegate: RedditTableViewCellDelegate?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.delegate?.buttonTapped(sender)
    }
    
}

protocol RedditTableViewCellDelegate: AnyObject { //https://forums.swift.org/t/class-only-protocols-class-vs-anyobject/11507
    func buttonTapped(_ sender: UIButton)
}
