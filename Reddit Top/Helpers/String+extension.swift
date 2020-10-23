//
//  String+extension.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/23/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isValidURL: Bool {
         return self.matches("^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$")
        
    }
}
