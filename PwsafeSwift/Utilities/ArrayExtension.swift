//
//  ArrayExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 04/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation


extension Array {
    func toChunks(_ chunkSize: Int) -> [[Element]] {
        return rangeSequence(0..<count, stride: chunkSize).map{ Array(self[$0]) }
    }
}

//too fancy?
func rangeSequence(_ range: Range<Int>, stride: Int) -> AnySequence<CountableRange<Int>> {
    var current = range.lowerBound
    
    let generator = AnyIterator {
        () -> CountableRange<Int>? in
        let prev = current
        current = min(current + stride, range.upperBound)
        return prev < range.upperBound ? prev..<current : nil
    }
    
    return AnySequence(generator)
}
