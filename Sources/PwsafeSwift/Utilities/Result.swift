//
//  Result.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 26/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    var value: Value? {
        guard case .success(let v) = self else { return nil }
        return v
    }
    
    var error: Error? {
        guard case .failure(let e) = self else { return nil }
        return e
    }
    
    func map<T>(_ f: (Value) -> T) -> Result<T> {
        return flatMap({ .success(f($0)) })
    }
    
    func flatMap<T>(_ f: (Value) -> Result<T>) -> Result<T> {
        switch self {
        case .success(let value):
            return f(value)
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
