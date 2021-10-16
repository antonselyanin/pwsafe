//
//  CollectionExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 25/02/2017.
//  Copyright © 2017 Anton Selyanin. All rights reserved.
//

import Foundation

internal extension Collection where Iterator.Element: Comparable & Hashable {
    func uniqueSorted(by areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool) -> [Iterator.Element] {
        return Array(Set(self)).sorted(by: areInIncreasingOrder)
    }
}

