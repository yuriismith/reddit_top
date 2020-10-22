//
//  ImageViewModel.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation
import UIKit

class ImageViewModel {
    
    init(image url: URL) {
        self.imageURL = url
        loadImage()
    }
    
    weak var delegate: ImageViewModelDelegate?
    
    private let imageURL: URL
    private (set) var image: UIImage?
    
    private func loadImage() {
        
        delegate?.didLoadImage()
    }
}

protocol ImageViewModelDelegate: AnyObject {
    func didLoadImage()
}
