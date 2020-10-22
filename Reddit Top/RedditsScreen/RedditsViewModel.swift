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
    private (set) var numberOfRows = 2 // this is temporarily
    
    private func loadReddits() {
        
        delegate?.didLoadReddits()
    }
    
}

protocol RedditsViewModelDelegate: AnyObject {
    func didLoadReddits()
}
