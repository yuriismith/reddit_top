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
    
    private var isLoadingcontent = false
    private var entries = [Entry]()
    
    func model(for indexPath: IndexPath) -> Entry? {
        return entries[safe: indexPath.row]
    }
    
    // Reddit documentation says that threads are updated so frequently, that it is a good idea to reload all previous Entries on pull to refresh
    /// Loads Entries and removes all previously loaded
    ///
    /// - Parameter limit: page size
    func loadReddits(limit: Int) {
        guard !isLoadingcontent else { return }
        isLoadingcontent = true
        NetworkManager.getTop(limit: limit) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingcontent = false
            switch result {
            case .success(let entries):
                strongSelf.entries = entries
                strongSelf.delegate?.didLoadReddits()
            case .failure(_):
                break
            }
        }
    }
    
    /// Loads more Entries after last loaded one
    ///
    /// - Parameter limit: page size
    func loadMoreRaddits(limit: Int, id: String? = nil) {
        guard !isLoadingcontent else { return }
        var last: String
        if let id = id {
            last = id
        } else if let lastId = entries.last?.id {
            last = lastId
        } else {
            delegate?.failedToLoadReddits()
            return
        }
        
        isLoadingcontent = true
        NetworkManager.getTop(limit: limit, after: last) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingcontent = false
            switch result {
            case .success(let newEntries):
                strongSelf.entries.append(contentsOf: newEntries)
                strongSelf.delegate?.didLoadMoreReddits()
            case .failure(_):
                break
            }
        }
    }
    
    func getThumbnail(_ url: URL, completion: @escaping ImageLoadingCompletion) {
        NetworkManager.loadImage(url: url, completion: completion)
    }
    
}

protocol RedditsViewModelDelegate: AnyObject {
    func didLoadReddits()
    func didLoadMoreReddits()
    func failedToLoadReddits()
}
