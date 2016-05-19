//
//  ArrayExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 04/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation


extension Array {
    func toChunks(chunkSize: Int) -> [[Element]] {
        return rangeSequence(0..<count, stride: chunkSize).map{ Array(self[$0]) }
    }
}

//too fancy?
func rangeSequence(range: Range<Int>, stride: Int) -> AnySequence<Range<Int>> {
    var current = range.startIndex
    
    let generator = AnyGenerator {
        () -> Range<Int>? in
        let prev = current
        current = min(current + stride, range.endIndex)
        return prev < range.endIndex ? prev..<current : nil
    }
    
    return AnySequence(generator)
}
