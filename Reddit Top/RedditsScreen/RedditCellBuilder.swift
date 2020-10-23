//
//  RedditCellBuilder.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/23/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import UIKit

class RedditCellBuilder {
    private let cell: RedditTableViewCell
    private let model: Entry
    
    init(cell: RedditTableViewCell, model: Entry) {
        self.cell = cell
        self.model = model
    }
    
    @discardableResult func addTitle() -> RedditCellBuilder {
        cell.titleLabel.text = model.title
        return self
    }
    
    @discardableResult func addAuthor() -> RedditCellBuilder {
        let hours = -1 * Int(model.date.timeIntervalSinceNow / 3600)
        let text = #""\#(model.author)", \#(hours) hours ago"#
        cell.authorLabel.text = text
        return self
    }
    
    @discardableResult func addComments() -> RedditCellBuilder {
        cell.commentsLable.text = "Comments: \(model.commentsCount)"
        return self
    }
    
    @discardableResult func checkImage(completion: @escaping (URL) -> Void) -> RedditCellBuilder {
        cell.imageURL = model.thumbnailURL
        if let url = model.thumbnailURL {
            showThumbnail()
            completion(url)
        } else {
            hideThumbnail()
        }
        return self
    }
    
    @discardableResult func set(image: UIImage?) -> RedditCellBuilder {
        guard let image = image, cell.imageURL == model.thumbnailURL else {
            hideThumbnail()
            return self
        }

        showThumbnail()
        cell.activityIndicator.isHidden = true
        cell.activityIndicator.stopAnimating()
        cell.thumbnailButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return self
    }
    
    func build() -> RedditTableViewCell {
        cell.selectionStyle = .none
        return cell
    }
    
    private func showThumbnail() {
        cell.thumbnailButton.isHidden = false
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        cell.authorLabelLeading.priority = UILayoutPriority.defaultLow
    }
    
    private func hideThumbnail() {
        cell.thumbnailButton.isHidden = true
        cell.activityIndicator.isHidden = true
        cell.activityIndicator.stopAnimating()
        cell.authorLabelLeading.priority = UILayoutPriority.defaultHigh
    }
}
