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
    fileprivate var restorationEntryId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        viewModel.delegate = self
        viewModel.loadReddits(limit: pageSize)
        showActivityFooter()
        configureRefreshControl()
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
    
    func configureRefreshControl () {
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        viewModel.loadReddits(limit: pageSize)
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
    
    
    // MARK: - State Restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        guard let index = self.tableView.indexPathsForVisibleRows?.first,
            let firstId = viewModel.model(for: index)?.id else { return }
        coder.encode(firstId, forKey: "firstEntry")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let firstId = coder.decodeObject(forKey: "firstEntry") as? String {
            self.restorationEntryId = firstId
        }
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        guard let firstId = self.restorationEntryId else { return }
        viewModel.loadMoreRaddits(limit: pageSize, id: firstId)
    }

}

extension RedditsTableViewController: RedditTableViewCellDelegate {
    func buttonTapped(_ sender: UIButton) {
        let position = sender.convert(sender.bounds.origin, to: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: position),
            let imageVC = storyboard?.instantiateViewController(withIdentifier: "ImageScreen") as? ImageViewController,
        let url = viewModel.model(for: indexPath)?.imageURL else { return }
        
        imageVC.viewModel = ImageViewModel(image: url)
        self.show(imageVC, sender: self)
 
    }
}

extension RedditsTableViewController: RedditsViewModelDelegate {
    func failedToLoadReddits() {
        self.tableView.refreshControl?.endRefreshing()
        hideActivityFooter()
    }
    
    
    func didLoadReddits() {
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        hideActivityFooter()
    }
    
    func didLoadMoreReddits() {
        self.tableView.reloadData()
        hideActivityFooter()
    }
    
}
