//
//  CollectionExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 25/02/2017.
//  Copyright © 2017 Anton Selyanin. All rights reserved.
//

import Foundation

internal extension Collection where Iterator.Element: Comparable, Iterator.Element: Hashable {
    internal func uniqueSorted(by areInIncreasingOrder: (Self.Iterator.Element, Self.Iterator.Element) -> Bool) -> [Self.Iterator.Element] {
        return Array(Set(self)).sorted(by: areInIncreasingOrder)
    }
}

