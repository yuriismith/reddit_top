//
//  Collection+Exension.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/23/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
