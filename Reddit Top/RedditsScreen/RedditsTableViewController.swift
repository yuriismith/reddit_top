//
//  RedditsTableViewController.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import UIKit

class RedditsTableViewController: UITableViewController {
    
    let viewModel = RedditsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        viewModel.delegate = self
        viewModel.loadReddits(limit: 5)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RedditTableViewCell.dequeue(for: tableView, at: indexPath)
        cell.delegate = self
        if let model = viewModel.model(for: indexPath) {
            let builder = RedditCellBuilder(cell: cell, model: model)
            builder.addTitle()
            .addAuthor()
            .addComments()
            .checkImage { [weak self] url in
                self?.viewModel.getThumbnail(url) { image in
                    builder.set(image: image)
                }
            }
            
            return builder.build()
        }
        
        return cell
    }

}

extension RedditsTableViewController: RedditTableViewCellDelegate {
    func buttonTapped(_ sender: UIButton) {
        let postion = sender.convert(sender.bounds.origin, to: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: postion),
            let imageVC = storyboard?.instantiateViewController(withIdentifier: "ImageScreen") as? ImageViewController else { return }
        let rowIndex =  indexPath.row
//        TODO: implement image URL getter
        imageVC.viewModel = ImageViewModel(image: URL(fileURLWithPath: ""))
        self.show(imageVC, sender: self)
 
    }
}

extension RedditsTableViewController: RedditsViewModelDelegate {
    func failedToLoadReddits() {
        // remove loading indicator
    }
    
    
    func didLoadReddits() {
        self.tableView.reloadData()
        self.viewModel.loadMoreRaddits(limit: 23)
    }
    
    func didLoadMoreReddits() {
        self.tableView.reloadData()
    }
    
}
