//
//  RedditsTableViewController.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import UIKit

final class RedditsTableViewController: UITableViewController {
    
    let viewModel = RedditsViewModel()
    fileprivate let oneThirdOfScreen = UIScreen.main.bounds.height / 3
    fileprivate let estimatedRowHeight: CGFloat = 100.0
    fileprivate lazy var pageSize: Int = {
        return Int((UIScreen.main.bounds.height + oneThirdOfScreen) / estimatedRowHeight)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        viewModel.delegate = self
        viewModel.loadReddits(limit: pageSize)
        showActivityFooter()
    }
    
    fileprivate func showActivityFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100.0))
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        
        self.tableView.tableFooterView = footerView
    }
    
    fileprivate func hideActivityFooter() {
        self.tableView.tableFooterView = nil
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (self.tableView.contentSize.height - self.oneThirdOfScreen - scrollView.frame.height) {
            self.viewModel.loadMoreRaddits(limit: self.pageSize)
            showActivityFooter()
        }
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
        hideActivityFooter()
    }
    
    func didLoadMoreReddits() {
        self.tableView.reloadData()
        hideActivityFooter()
    }
    
}
