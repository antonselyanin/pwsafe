//
//  ByteUtils.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

func rotateLeft(_ v:UInt8, n:UInt8) -> UInt8 {
    return ((v << n) & 0xFF) | (v >> (8 - n))
}

func rotateLeft(_ v:UInt16, n:UInt16) -> UInt16 {
    return ((v << n) & 0xFFFF) | (v >> (16 - n))
}

func rotateLeft(_ v:UInt32, n:UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}

func rotateLeft(_ x:UInt64, n:UInt64) -> UInt64 {
    return (x << n) | (x >> (64 - n))
}

func rotateRight(_ x:UInt16, n:UInt16) -> UInt16 {
    return (x >> n) | (x << (16 - n))
}

func rotateRight(_ x:UInt32, n:UInt32) -> UInt32 {
    return (x >> n) | (x << (32 - n))
}

func rotateRight(_ x:UInt64, n:UInt64) -> UInt64 {
    return ((x >> n) | (x << (64 - n)))
}

//TODO: use better PRNG
func generateRandomBytes(_ count: Int) -> [UInt8] {
    var bytes = [UInt8](repeating: 0, count: count)
    arc4random_buf(&bytes, bytes.count)
    return bytes
}
