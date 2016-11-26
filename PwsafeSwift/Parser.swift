//
//  Parser.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 19/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

typealias ParserResult<Parsed> = (remainder: Data, parsed: Parsed)?

protocol ParserProtocol {
    associatedtype Parsed
    
    var parse: (Data) -> ParserResult<Parsed> { get }
    
    func map<T>(_ f: @escaping (Parsed) -> T) -> Parser<T>
    
    func flatMap<T>(_ f: @escaping (Parsed) -> Parser<T>) -> Parser<T>
}

struct Parser<Parsed>: ParserProtocol {
    let parse: (Data) -> ParserResult<Parsed>
}

extension ParserProtocol {
    static func pure<T>(_ t: T) -> Parser<T> {
        return Parser<T> { (input) -> ParserResult<T> in
            return (input, t)
        }
    }
    
    static func empty<T>() -> Parser<T> {
        return Parser<T> { (input) -> ParserResult<T> in
            return nil
        }
    }
    
    func map<T>(_ f: @escaping (Parsed) -> T) -> Parser<T> {
        //TODO: function composition here
        return flatMap({ .pure(f($0)) })
    }
    
    func flatMap<T>(_ f: @escaping (Parsed) -> Parser<T>) -> Parser<T> {
        // TODO: simplify
        return Parser<T> { (input) -> ParserResult<T> in
            return self.parse(input).flatMap { (remainder: Data, parsed: Parsed) -> (Data, T)? in
                return f(parsed).parse(remainder)
            }
        }
    }
}

extension ParserProtocol {
    var many: Parser<[Parsed]> {
        return Parser { initialInput in
            var input = initialInput
            var result: [Parsed] = []
            
            while let (remainder, parsed) = self.parse(input) {
                result.append(parsed)
                input = remainder
            }
            
            return (input, result)
        }
    }
    
    func aligned(blockSize: Int) -> Parser<Parsed> {
        return Parser { input in
            return self.parse(input).flatMap {
                let (remainder, parsed) = $0
                let readSize = input.count - remainder.count
                
                guard readSize % blockSize != 0 else { return $0 }
                
                let unaligned = blockSize - readSize % blockSize
                let alignedRemainder = Data(remainder.suffix(remainder.count - unaligned))
                return (alignedRemainder, parsed)
            }
        }
    }
}

extension ParserProtocol where Parsed == Data {
    var bytes: Parser<[UInt8]> {
        return map { (data: Data) -> [UInt8] in
            //TODO: extract function or var
            return data.withUnsafeBytes {
                return [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
            }
        }
    }
    
    func cut(requiredSuffix: [UInt8]) -> Parser<Data> {
        return Parser<Data> { input in
            return self.parse(input).flatMap { result in
                let potentialSuffix = result.parsed.suffix(requiredSuffix.count)
                guard Data(bytes: requiredSuffix) == Data(potentialSuffix) else {
                    return nil
                }
                
                let prefix = result.parsed.prefix(upTo: potentialSuffix.startIndex)
                
                return (result.remainder, Data(prefix))
            }
        }
    }
}

enum Parsers {
    //TODO: rename
    static func read(_ bytesToRead: Int) -> Parser<Data> {
        return Parser<Data> { (input) -> ParserResult<Data> in
            guard bytesToRead <=  input.count else { return nil }
            
            let remainder = input.subdata(in: bytesToRead ..< input.endIndex)
            let parsed = input.subdata(in: 0 ..< bytesToRead)
            
            return (remainder, parsed)
        }
    }
    
    static func expect(_ bytes: [UInt8]) -> Parser<Data> {
        return read(bytes.count).flatMap {
            guard $0 == Data(bytes: bytes) else { return .empty() }
            return .pure($0)
        }
    }
    
    //TODO: Remove this? We don't need string version
    static func expect(_ value: String) -> Parser<String> {
        return expect(value.utf8Bytes()).map({ _ in value })
    }
    
    static func readAll(leave tailSize: Int = 0) -> Parser<Data> {
        return Parser<Data> { input in
            guard tailSize <= input.count else { return nil }
            
            return (Data(input.suffix(tailSize)), Data(input.prefix(input.count - tailSize)))
        }
    }
    
    //TODO: rename
    static func read<T: ByteArrayConvertible>() -> Parser<T> {
        return read(MemoryLayout<T>.size)
            .bytes
            .map(T.init(littleEndianBytes:))
    }
}
