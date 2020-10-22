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
        viewModel.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RedditTableViewCell.dequeue(for: tableView, at: indexPath)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let imageVC = segue.destination as? ImageViewController else { return }
//        let viewModel = ImageViewModel(image: URL(fileURLWithPath: ""))
//        imageVC.viewModel = viewModel
//        
//    }
    
    
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
        
//        self.performSegue(withIdentifier: "showImage", sender: self)
        
    }
}

extension RedditsTableViewController: RedditsViewModelDelegate {
    
    func didLoadReddits() {
        self.tableView.reloadData()
    }
    
}
