//
//  ByteUtils.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

func rotateLeft(v:UInt8, n:UInt8) -> UInt8 {
    return ((v << n) & 0xFF) | (v >> (8 - n))
}

func rotateLeft(v:UInt16, n:UInt16) -> UInt16 {
    return ((v << n) & 0xFFFF) | (v >> (16 - n))
}

func rotateLeft(v:UInt32, n:UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}

func rotateLeft(x:UInt64, n:UInt64) -> UInt64 {
    return (x << n) | (x >> (64 - n))
}

func rotateRight(x:UInt16, n:UInt16) -> UInt16 {
    return (x >> n) | (x << (16 - n))
}

func rotateRight(x:UInt32, n:UInt32) -> UInt32 {
    return (x >> n) | (x << (32 - n))
}

func rotateRight(x:UInt64, n:UInt64) -> UInt64 {
    return ((x >> n) | (x << (64 - n)))
}

func generateRandomBytes(count: Int) -> [UInt8] {
    var bytes = [UInt8](count: count, repeatedValue: 0)
    arc4random_buf(&bytes, bytes.count)
    return bytes
}