//
//  Twofish.swift
//  CryptoSwift
//
//  Created by Anton Selyanin on 13/08/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

final class Twofish2 {
    enum Error: ErrorType {
        case BlockSizeExceeded
    }
    
    enum TwofishVariant:Int {
        case twofish128 = 1, twofish192, twofish256
    }
    
    let blockMode:BlockMode
    static let blockSize:Int = 16 // 128 /8
    
    var variant:TwofishVariant {
        switch (self.key.count * 8) {
        case 128:
            return .twofish128
        case 192:
            return .twofish192
        case 256:
            return .twofish256
        default:
            preconditionFailure("Unknown Twofish variant for given key.")
        }
    }

    private let key:[UInt8]
    private let iv:[UInt8]?
    
    private var skey:twofish_key

    init?(key:[UInt8], iv:[UInt8], blockMode:BlockMode = CBCMode()) {
        self.key = key
        self.iv = iv
        self.blockMode = blockMode
        
        self.skey = twofish_key()
        twofish_setup(key, keylen: key.count, num_rounds: 0, skey: skey)
        
//        if (blockMode.needIV && iv.count != Twofish.blockSize) {
//            assert(false, "Block size and Initialization Vector must be the same length!")
//            return nil
//        }
    }
    
    convenience init?(key:[UInt8], blockMode:BlockMode = CBCMode()) {
        // default IV is all 0x00...
        let defaultIV = [UInt8](count: Twofish2.blockSize, repeatedValue: 0)
        self.init(key: key, iv: defaultIV, blockMode: blockMode)
    }
    
    convenience init?(key:String, iv:String, blockMode:BlockMode = CBCMode()) {
        if let kkey = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes(), let iiv = iv.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes() {
            self.init(key: kkey, iv: iiv, blockMode: blockMode)
        }
        return nil
    }
    
    /**
    Encrypt message. If padding is necessary, then PKCS7 padding is added and needs to be removed after decryption.
    
    - parameter message: Plaintext data
    
    - returns: Encrypted data
    */
    
    func encrypt(bytes:[UInt8]) throws -> [UInt8] {
        let blocks = bytes.toChunks(Twofish2.blockSize)
        return try blockMode.encryptInput(blocks, iv: self.iv, cipherOperation: encryptBlock)
    }
    
    private func encryptBlock(block:[UInt8]) -> [UInt8]? {
        //todo: fix out block size???
        var out:[UInt8] = [UInt8](count: 16, repeatedValue: 0)
        
        twofish_ecb_encrypt(block, ct: &out, skey: skey)
        
        return out
    }
    
    func decrypt(bytes:[UInt8]) throws -> [UInt8] {
        if bytes.count % Twofish2.blockSize != 0 {
            throw Error.BlockSizeExceeded
        }
        
        let blocks = bytes.toChunks(Twofish2.blockSize)
        return try blockMode.decryptInput(blocks, iv: self.iv, cipherOperation: decryptBlock)
    }
    
    private func decryptBlock(block:[UInt8]) -> [UInt8]? {
        //todo: fix out block size???
        var out:[UInt8] = [UInt8](count: 16, repeatedValue: 0)
    
        twofish_ecb_decrypt(block, pt:&out, skey: skey)
        
        return out
    }

}

enum CryptResult:Int {
    case CRYPT_OK = 0           /* Result OK */
    case CRYPT_ERROR            /* Generic Error */
    case CRYPT_NOP              /* Not a failure but no operation was performed */
    
    case CRYPT_INVALID_KEYSIZE  /* Invalid key size given */
    case CRYPT_INVALID_ROUNDS   /* Invalid number of rounds */
    case CRYPT_FAIL_TESTVECTOR  /* Algorithm failed test vectors */
    
    case CRYPT_BUFFER_OVERFLOW  /* Not enough space for output */
    
    case CRYPT_MEM              /* Out of memory */
    
    case CRYPT_INVALID_ARG      /* Generic invalid argument */
};

/**
Implementation of Twofish by Tom St Denis
*/

/* min_key_length = 16, max_key_length = 32, block_length = 16, default_rounds = 16 */

/* the two polynomials */
let MDS_POLY = 0x169
let RS_POLY = 0x14D

/* The 4x4 MDS Linear Transform */

let MDS:[[UInt8]] = [
    [ 0x01, 0xEF, 0x5B, 0x5B ],
    [ 0x5B, 0xEF, 0xEF, 0x01 ],
    [ 0xEF, 0x5B, 0x01, 0xEF ],
    [ 0xEF, 0x01, 0xEF, 0x5B ]
]

/* The 4x8 RS Linear Transform */
let RS:[[UInt8]] = [
    [ 0x01, 0xA4, 0x55, 0x87, 0x5A, 0x58, 0xDB, 0x9E ],
    [ 0xA4, 0x56, 0x82, 0xF3, 0x1E, 0xC6, 0x68, 0xE5 ],
    [ 0x02, 0xA1, 0xFC, 0xC1, 0x47, 0xAE, 0x3D, 0x19 ],
    [ 0xA4, 0x55, 0x87, 0x5A, 0x58, 0xDB, 0x9E, 0x03 ]
]

/* sbox usage orderings */
let qord:[[UInt8]] = [
    [ 1, 1, 0, 0, 1 ],
    [ 0, 1, 1, 0, 0 ],
    [ 0, 0, 0, 1, 1 ],
    [ 1, 0, 1, 1, 0 ]
];

func sbox(i:Int, _ x:Int) -> UInt8 {
    return SBOX[i][x & 255]
}

func sbox(i:Int, _ x:UInt8) -> UInt8 {
    return sbox(i, Int(x))
}

func mds_column_mult(x:UInt8, _ i:Int) -> UInt32 {
    return mds_tab[i][Int(x)]
}

/* Computes [y0 y1 y2 y3] = MDS . [x0 x1 x2 x3] */
func mds_mult(inp:[UInt8], inout _ out:[UInt8])
{
    var tmp:UInt32 = 0
    for x in 0..<4 {
        tmp = tmp ^ mds_column_mult(inp[x], x)
    }
    storeUInt32(tmp, &out)
}

/* computes [y0 y1 y2 y3] = RS . [x0 x1 x2 x3 x4 x5 x6 x7] */
func rs_mult(inp:[UInt8], inputStartIndex:Int, inout _ out:[UInt8], startIndex:Int)
{
    let tmp1 = rs_tab0[Int(inp[0 + inputStartIndex])]
        ^ rs_tab1[Int(inp[1 + inputStartIndex])]
        ^ rs_tab2[Int(inp[2 + inputStartIndex])]
        ^ rs_tab3[Int(inp[3 + inputStartIndex])]
    let tmp2 = rs_tab4[Int(inp[4 + inputStartIndex])]
        ^ rs_tab5[Int(inp[5 + inputStartIndex])]
        ^ rs_tab6[Int(inp[6 + inputStartIndex])]
        ^ rs_tab7[Int(inp[7 + inputStartIndex])]
    storeUInt32(tmp1 ^ tmp2, &out, startIndex:startIndex)
}

/* computes h(x) */
func h_func(inp:[UInt8], inout _ out:[UInt8],_ M:[UInt8],_ k:Int,_ offset:Int)
{
    var y = [UInt8](count: 4, repeatedValue: 0)
    for x in 0..<4 {
        y[x] = inp[x]
    }
    switch (k) {
    case 4:
        y[0] = sbox(1, y[0]) ^ M[4 * (6 + offset) + 0]
        y[1] = (sbox(0, y[1]) ^ M[4 * (6 + offset) + 1])
        y[2] = (sbox(0, y[2]) ^ M[4 * (6 + offset) + 2])
        y[3] = (sbox(1, y[3]) ^ M[4 * (6 + offset) + 3])
        fallthrough
    case 3:
        y[0] = (sbox(1, y[0]) ^ M[4 * (4 + offset) + 0])
        y[1] = (sbox(1, y[1]) ^ M[4 * (4 + offset) + 1])
        y[2] = (sbox(0, y[2]) ^ M[4 * (4 + offset) + 2])
        y[3] = (sbox(0, y[3]) ^ M[4 * (4 + offset) + 3])
        fallthrough
    case 2:
        y[0] = (sbox(1, Int(sbox(0, Int(sbox(0, Int(y[0])) ^ M[4 * (2 + offset) + 0])) ^ M[4 * (0 + offset) + 0])))
        y[1] = (sbox(0, Int(sbox(0, Int(sbox(1, Int(y[1])) ^ M[4 * (2 + offset) + 1])) ^ M[4 * (0 + offset) + 1])))
        y[2] = (sbox(1, Int(sbox(1, Int(sbox(0, Int(y[2])) ^ M[4 * (2 + offset) + 2])) ^ M[4 * (0 + offset) + 2])))
        y[3] = (sbox(0, Int(sbox(1, Int(sbox(1, Int(y[3])) ^ M[4 * (2 + offset) + 3])) ^ M[4 * (0 + offset) + 3])))
    default:
        break;
    }
    mds_mult(y, &out);
}

func byte(x: UInt32, n: Int) -> Int {
    return Int(x >> UInt32(8 * n)) & 0xFF
}

/* the G function */
func g_func(x:UInt32, _ skey:twofish_key) -> UInt32 {
    return skey.S[0][byte(x, n: 0)] ^ skey.S[1][byte(x, n: 1)] ^ skey.S[2][byte(x, n: 2)] ^ skey.S[3][byte(x, n: 3)]
}

func g1_func(x:UInt32, _ skey:twofish_key) -> UInt32 {
    return skey.S[1][byte(x, n: 0)] ^ skey.S[2][byte(x, n: 1)] ^ skey.S[3][byte(x, n: 2)] ^ skey.S[0][byte(x, n: 3)]
}

class twofish_key {
    var S:[[UInt32]] = [[UInt32]](count: 4, repeatedValue: [UInt32](count: 256, repeatedValue: 0))
    var K = [UInt32](count: 40, repeatedValue: 0)
    
    init() {}
}

/*
Initialize the Twofish block cipher
@param key The symmetric key you wish to pass
@param keylen The key length in bytes
@param num_rounds The number of rounds desired (0 for default)
@param skey The key in as scheduled by this function.
@return CRYPT_OK if successful
*/
func twofish_setup(key:[UInt8], keylen:Int, num_rounds:Int, skey:twofish_key) -> CryptResult
{
    var S:[[UInt8]] = [[UInt8]](count: 4, repeatedValue: [UInt8](count: 4, repeatedValue: 0))
    var M = [UInt8](count: 32, repeatedValue: 0)
    var tmp = [UInt8](count: 4, repeatedValue: 0)
    var tmp2 = [UInt8](count: 4, repeatedValue: 0)
    
    /* invalid arguments? */
    if (num_rounds != 16 && num_rounds != 0) {
        return .CRYPT_INVALID_ROUNDS
    }
    
    if (keylen != 16 && keylen != 24 && keylen != 32) {
        return .CRYPT_INVALID_KEYSIZE
    }
    
    /* k = keysize/64 [but since our keysize is in bytes...] */
    let k = keylen / 8;
    
    /* copy the key into M */
    for x in 0..<keylen {
        M[x] = key[x];
    }
    
    /* create the S[..] words */
    for x in 0..<k {
//        rs_mult(M+(x*8), S+(x*4));
        rs_mult(M, inputStartIndex:x * 8, &S[x], startIndex:0);
    }
    
    /* make subkeys */
    for x in 0..<20 {
        var A:UInt32 = 0
        var B:UInt32 = 0
        /* A = h(p * 2x, Me) */
        for y in 0..<4 {
            tmp[y] = UInt8(x + x)
        }
        h_func(tmp, &tmp2, M, k, 0);
        A = loadUInt32(tmp2)
        
        /* B = ROL(h(p * (2x + 1), Mo), 8) */
        for y in 0..<4 {
            tmp[y] = UInt8(x + x + 1)
        }
        h_func(tmp, &tmp2, M, k, 1)
        B = loadUInt32(tmp2)
        B = rotateLeft(B, n: 8)
        
        /* K[2i]   = A + B */
//        skey.K[x+x] = (A + B) & 0xFFFFFFFF
        skey.K[x + x] = A &+ B
        
        /* K[2i+1] = (A + 2B) <<< 9 */
        skey.K[x + x + 1] = rotateLeft(B &+ B &+ A, n: 9)
    }
    
    // index hack
    func S_(index:Int) -> UInt8 {
        let i = index / 4
        let j = index % 4
        return S[i][j]
    }
    
    /* make the sboxes (large ram variant) */
    if (k == 2) {
        for x in 0..<256 {
            let tmpx0 = UInt8(sbox(0, x))
            let tmpx1 = UInt8(sbox(1, x))
            skey.S[0][x] = mds_column_mult(sbox(1, (sbox(0, tmpx0 ^ S_(0)) ^ S_(4))),0)
            skey.S[1][x] = mds_column_mult(sbox(0, (sbox(0, tmpx1 ^ S_(1)) ^ S_(5))),1)
            skey.S[2][x] = mds_column_mult(sbox(1, (sbox(1, tmpx0 ^ S_(2)) ^ S_(6))),2)
            skey.S[3][x] = mds_column_mult(sbox(0, (sbox(1, tmpx1 ^ S_(3)) ^ S_(7))),3)
        }
    } else if (k == 3) {
        for x in 0..<256 {
            let tmpx0 = UInt8(sbox(0, x))
            let tmpx1 = UInt8(sbox(1, x))
            skey.S[0][x] = mds_column_mult(sbox(1, (sbox(0, sbox(0, tmpx1 ^ S_(0)) ^ S_(4)) ^ S_(8))),0)
            skey.S[1][x] = mds_column_mult(sbox(0, (sbox(0, sbox(1, tmpx1 ^ S_(1)) ^ S_(5)) ^ S_(9))),1)
            skey.S[2][x] = mds_column_mult(sbox(1, (sbox(1, sbox(0, tmpx0 ^ S_(2)) ^ S_(6)) ^ S_(10))),2)
            skey.S[3][x] = mds_column_mult(sbox(0, (sbox(1, sbox(1, tmpx0 ^ S_(3)) ^ S_(7)) ^ S_(11))),3)
        }
    } else {
        for x in 0..<256 {
            let tmpx0 = UInt8(sbox(0, x))
            let tmpx1 = UInt8(sbox(1, x))
            skey.S[0][x] = mds_column_mult(sbox(1, (sbox(0, sbox(0, sbox(1, tmpx1 ^ S_(0)) ^ S_(4)) ^ S_(8)) ^ S_(12))),0)
            skey.S[1][x] = mds_column_mult(sbox(0, (sbox(0, sbox(1, sbox(1, tmpx0 ^ S_(1)) ^ S_(5)) ^ S_(9)) ^ S_(13))),1)
            skey.S[2][x] = mds_column_mult(sbox(1, (sbox(1, sbox(0, sbox(0, tmpx0 ^ S_(2)) ^ S_(6)) ^ S_(10)) ^ S_(14))),2)
            skey.S[3][x] = mds_column_mult(sbox(0, (sbox(1, sbox(1, sbox(0, tmpx1 ^ S_(3)) ^ S_(7)) ^ S_(11)) ^ S_(15))),3)
        }
    }
    return .CRYPT_OK;
}

/*
Encrypts a block of text with Twofish
@param pt The input plaintext (16 bytes)
@param ct The output ciphertext (16 bytes)
@param skey The key as scheduled
*/
func twofish_ecb_encrypt(pt:[UInt8], inout ct:[UInt8], skey:twofish_key)
{
    var a:UInt32
    var b:UInt32
    var c:UInt32
    var d:UInt32
    var ta:UInt32
    var tb:UInt32
    var tc:UInt32
    var td:UInt32
    var t1:UInt32
    var t2:UInt32
    var K:[UInt32] = skey.K // ?????
    
    a = loadUInt32(pt, startIndex: 0)
    b = loadUInt32(pt, startIndex: 4)
    c = loadUInt32(pt, startIndex: 8)
    d = loadUInt32(pt, startIndex: 12)
    a ^= skey.K[0]
    b ^= skey.K[1]
    c ^= skey.K[2]
    d ^= skey.K[3]
    
    var kShift = 8
    for _ in 0..<8 {
        t2 = g1_func(b, skey)
        t1 = g_func(a, skey) &+ t2
        c  = rotateRight(c ^ (t1 &+ K[0 + kShift]), n: 1)
        d  = rotateLeft(d, n: 1) ^ (t2 &+ t1 &+ K[1 + kShift])
        
        t2 = g1_func(d, skey)
        t1 = g_func(c, skey) &+ t2
        a  = rotateRight(a ^ (t1 &+ K[2 + kShift]), n: 1)
        b  = rotateLeft(b, n: 1) ^ (t2 &+ t1 &+ K[3 + kShift])
        kShift += 4
    }
    
    /* output with "undo last swap" */
    ta = c ^ skey.K[4]
    tb = d ^ skey.K[5]
    tc = a ^ skey.K[6]
    td = b ^ skey.K[7]
    
    /* store output */
    storeUInt32(ta, &ct, startIndex: 0)
    storeUInt32(tb, &ct, startIndex: 4)
    storeUInt32(tc, &ct, startIndex: 8)
    storeUInt32(td, &ct, startIndex: 12)
}

/*
Decrypts a block of text with Twofish
@param ct The input ciphertext (16 bytes)
@param pt The output plaintext (16 bytes)
@param skey The key as scheduled
*/
func twofish_ecb_decrypt(ct:[UInt8], inout pt:[UInt8], skey:twofish_key)
{
    var a:UInt32
    var b:UInt32
    var c:UInt32
    var d:UInt32
    var ta:UInt32
    var tb:UInt32
    var tc:UInt32
    var td:UInt32
    var t1:UInt32
    var t2:UInt32
    var K:[UInt32] = skey.K // ?????
    
    /* load input */
    ta = loadUInt32(ct, startIndex: 0)
    tb = loadUInt32(ct, startIndex: 4)
    tc = loadUInt32(ct, startIndex: 8)
    td = loadUInt32(ct, startIndex: 12)
    
    /* undo undo final swap */
    a = tc ^ skey.K[6];
    b = td ^ skey.K[7];
    c = ta ^ skey.K[4];
    d = tb ^ skey.K[5];
    
    var kShift = 36
    for _ in 0..<8 {
        t2 = g1_func(d, skey);
        t1 = g_func(c, skey) &+ t2;
        a = rotateLeft(a, n:1) ^ (t1 &+ K[2 + kShift])
        b = rotateRight(b ^ (t2 &+ t1 &+ K[3 + kShift]), n: 1)
        
        t2 = g1_func(b, skey)
        t1 = g_func(a, skey) &+ t2
        c = rotateLeft(c, n:1) ^ (t1 &+ K[0 + kShift])
        d = rotateRight(d ^ (t2 &+  t1 &+ K[1 + kShift]), n: 1)
        kShift -= 4
    }
    
    /* pre-white */
    a ^= skey.K[0]
    b ^= skey.K[1]
    c ^= skey.K[2]
    d ^= skey.K[3]
    
    /* store */
    storeUInt32(a, &pt, startIndex: 0)
    storeUInt32(b, &pt, startIndex: 4)
    storeUInt32(c, &pt, startIndex: 8)
    storeUInt32(d, &pt, startIndex: 12)
}

//MARK: - Utilities

func loadUInt32(y:[UInt8]) -> UInt32 {
    return loadUInt32(y, startIndex: 0)
}

func loadUInt32(y:[UInt8], startIndex:Int) -> UInt32 {
    let b3 = UInt32(y[3 + startIndex])
    let b2 = UInt32(y[2 + startIndex])
    let b1 = UInt32(y[1 + startIndex])
    let b0 = UInt32(y[0 + startIndex])
    
    return (b3 << 24) |
        (b2 << 16) |
        (b1 << 8)  |
        (b0)
}

func storeUInt32(x:UInt32, inout _ y:[UInt8]) {
    storeUInt32(x, &y, startIndex: 0)
}

func storeUInt32(x:UInt32, inout _ y:[UInt8], startIndex:Int) {
    y[3 + startIndex] = UInt8((x >> 24) & 255)
    y[2 + startIndex] = UInt8((x >> 16) & 255)
    y[1 + startIndex] = UInt8((x >> 8) & 255)
    y[0 + startIndex] = UInt8(x & 255)
}