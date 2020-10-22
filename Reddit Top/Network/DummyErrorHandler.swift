//
//  DummyErrorHandler.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation
import UIKit

class DummyErrorHandler {
    
    class func handle(_ error: Error) {
        presentError(title: "Oops...", message: error.localizedDescription)
    }
    
    class func presentDefaultError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Oops...", message: "Something went wrong, please try again later.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(dismissAction)
            alert.show()
        }
    }
    
    private class func presentError(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // Action
            }
            alert.addAction(dismissAction)
            alert.show()
        }
        
    }
    
}

extension UIAlertController {
    func show() {
        DispatchQueue.main.async {
            let window = UIWindow(frame: UIScreen.main.bounds)
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            window.rootViewController = vc
            window.windowLevel = UIWindow.Level.alert + 1
            window.makeKeyAndVisible()
            vc.present(self, animated: true, completion: nil)
        }
    }
}
