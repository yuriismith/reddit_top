//
//  ValidationError.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation

struct ValidationError: Codable {
    //    let field, message: String
    let name, message: String
}

struct ValidationErrorResponse: Codable {
    let success: Bool
    let errors: [ValidationError]
}

/*
 Please note that wrong JSON for 422 (validaton) response provided
 on https://apiecho.cf/doc/
 
 Provided:
 {
 "success": false,
 "data": "{}",
 "errors": [
 {
 "field": "string",
 "message": "string"
 }
 ]
 }
 
 Actual:
 Provided:
 {
 "success": false,
 "data": "{}",
 "errors": [
 {
 "name": "string",
 "message": "string"
 }
 ]
 }
 
 statusCode 400 JSON format correct
 {
 "success": false,
 "data": "{}",
 "errors": [
 {
 "name": "string",
 "message": "string",
 "code": 0,
 "status": 0
 }
 ]
 }
 */

struct GeneralError: Codable {
    let name, message: String
}

struct GeneralErrorResponse: Codable {
    let success: Bool
    let errors: [GeneralError]
}
