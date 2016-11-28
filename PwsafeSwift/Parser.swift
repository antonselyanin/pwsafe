//
//  Parser.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 19/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case error
}

struct Parsed<Value> {
    let remainder: Data
    let value: Value
}

typealias ParserResult<Value> = Result<Parsed<Value>>

protocol ParserProtocol {
    associatedtype Value
    
    var parse: (Data) -> ParserResult<Value> { get }
    
    func map<T>(_ f: @escaping (Value) -> T) -> Parser<T>
    
    func flatMap<T>(_ f: @escaping (Value) -> Parser<T>) -> Parser<T>
}

struct Parser<Value>: ParserProtocol {
    let parse: (Data) -> ParserResult<Value>
}

extension ParserProtocol {
    static func pure<T>(_ t: T) -> Parser<T> {
        return Parser<T> { (input) -> ParserResult<T> in
            return .success(Parsed(remainder: input, value: t))
        }
    }
    
    static func empty<T>() -> Parser<T> {
        return Parser<T> { (input) -> ParserResult<T> in
            return .failure(ParserError.error)
        }
    }
    
    func map<T>(_ f: @escaping (Value) -> T) -> Parser<T> {
        //TODO: function composition here
        return flatMap({ .pure(f($0)) })
    }
    
    func flatMap<T>(_ f: @escaping (Value) -> Parser<T>) -> Parser<T> {
        // TODO: simplify
        return Parser<T> { (input) -> ParserResult<T> in
            return self.parse(input).flatMap { (parsed: Parsed) -> ParserResult<T> in
                return f(parsed.value).parse(parsed.remainder)
            }
        }
    }
}

extension ParserProtocol {
    var many: Parser<[Value]> {
        return Parser { initialInput in
            var input = initialInput
            var result: [Value] = []
            
            while let value = self.parse(input).value {
                result.append(value.value)
                input = value.remainder
            }
            
            return .success(Parsed(remainder: input, value: result))
        }
    }
    
    func aligned(blockSize: Int) -> Parser<Value> {
        return Parser { input in
            return self.parse(input).flatMap { parsed in
                let readSize = input.count - parsed.remainder.count
                
                guard readSize % blockSize != 0 else { return .success(parsed) }
                
                let unaligned = blockSize - readSize % blockSize
                let alignedRemainder = Data(parsed.remainder.suffix(parsed.remainder.count - unaligned))
                return .success(Parsed(remainder: alignedRemainder, value: parsed.value))
            }
        }
    }
}

extension ParserProtocol where Value == Data {
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
                let potentialSuffix = result.value.suffix(requiredSuffix.count)
                guard Data(bytes: requiredSuffix) == Data(potentialSuffix) else {
                    return .failure(ParserError.error)
                }
                
                let prefix = result.value.prefix(upTo: potentialSuffix.startIndex)
                
                return .success(Parsed(remainder: result.remainder, value: Data(prefix)))
            }
        }
    }
}

enum Parsers {
    //TODO: rename
    static func read(_ bytesToRead: Int) -> Parser<Data> {
        return Parser<Data> { (input) -> ParserResult<Data> in
            guard bytesToRead <= input.count else { return .failure(ParserError.error) }
            
            let remainder = input.subdata(in: bytesToRead ..< input.endIndex)
            let value = input.subdata(in: 0 ..< bytesToRead)
            
            return .success(Parsed(remainder: remainder, value: value))
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
            guard tailSize <= input.count else { return .failure(ParserError.error) }
            
            let remainder = Data(input.suffix(tailSize))
            let value = Data(input.prefix(input.count - tailSize))
            
            return .success(Parsed(remainder: remainder, value: value))
        }
    }
    
    //TODO: rename
    static func read<T: ByteArrayConvertible>() -> Parser<T> {
        return read(MemoryLayout<T>.size)
            .bytes
            .map(T.init(littleEndianBytes:))
    }
}
