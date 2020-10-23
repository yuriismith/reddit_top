//
//  Cache.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/23/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import UIKit.UIImage

final class Cache {
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = 200
        cache.totalCostLimit = 200 * 1024 * 1024
        
        return cache
    }()

    private let lock = NSLock()
    
    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer {
            lock.unlock()
        }
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return image
        }
        return nil
    }
    
    func addImage(_ image: UIImage?, for url: URL) {
        guard let image = image else {
            removeImage(for: url)
            return
        }
        
        lock.lock()
        imageCache.setObject(image, forKey: url as AnyObject, cost: 1)
        lock.unlock()
    }
    
    func removeImage(for url: URL) {
        lock.lock()
        imageCache.removeObject(forKey: url as AnyObject)
        lock.unlock()
    }
}
