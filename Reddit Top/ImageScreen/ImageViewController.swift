//
//  ImageViewController.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ImageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        showImage()
    }

    private func setupUI() {
        scrollView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))
    }
    
    private func showImage() {
        guard let image = viewModel.image else {
            showActivity()
            return
        }
        self.imageView.image = image
        hideActivity()
    }
    
    private func showActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    @objc private func saveImage() {
        guard let image = self.viewModel.image else { return }
        ImageSaver().writeToPhotoAlbum(image)
    }
    
    // MARK: - State Restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        guard let image = self.viewModel.image else { return }
        coder.encode(image, forKey: "imageToRestore")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let image = coder.decodeObject(forKey: "imageToRestore") as? UIImage {
            self.imageView.image = image
        }
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        print("applicationFinishedRestoringState")
    }
    
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImageViewController: ImageViewModelDelegate {
    func didLoadImage() {
        showImage()
    }
}
