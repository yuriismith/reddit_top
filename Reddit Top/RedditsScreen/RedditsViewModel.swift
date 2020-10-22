//
//  RedditsViewModel.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation

class RedditsViewModel {
    
    weak var delegate: RedditsViewModelDelegate?
    let numberOfSections = 1
    var numberOfRows: Int {
        return entries.count
    }
    private var entries = [Entry]()
    
    func loadReddits() {
        NetworkManager.getTop(limit: 5) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let entries):
                strongSelf.entries = entries
                strongSelf.delegate?.didLoadReddits()
            case .failure(_):
                break
            }
        }
        
    }
    
}

protocol RedditsViewModelDelegate: AnyObject {
    func didLoadReddits()
}
