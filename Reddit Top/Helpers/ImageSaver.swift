//
//  ImageSaver.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/23/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import UIKit.UIImage


class ImageSaver: NSObject {
    func writeToPhotoAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        if let error = error {
            DummyErrorHandler.handle(error)
        } else {
            let alert = UIAlertController(title: "Congrats", message: "Image has been succesfully saved to you Photo library", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(dismissAction)
            alert.show()
        }
    }
}
