//
//  ParserOperators.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 23/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

//TODO: test!
// Functor fmap (<$>)
func <^> <A, B>(f: @escaping (A) -> B, p: Parser<A>) -> Parser<B> {
    return p.map(f)
}

//TODO: test!
//TODO: simplify!
// Applicative sequential application
func <*> <A, B>(p: Parser<(A) -> B>, q: Parser<A>) -> Parser<B> {
    return Parser<B> { (input) -> ParserResult<B> in
        guard case .success(let parsed1) = p.parse(input),
            case .success(let parsed2) = q.parse(parsed1.remainder) else { return .failure(ParserError.error) }
        
        return .success(Parsed(remainder: parsed2.remainder, value: parsed1.value(parsed2.value)))
    }
}


/**
 sequence actions, discarding right (value of the second argument)
 
 Expected function type: `f a -> f b -> f a`
 Haskell `infixl 4`
 */
//TODO: simplify!
func <* <A, B>(p: Parser<A>, q: Parser<B>) -> Parser<A> {
    return Parser<A> { (input: Data) -> ParserResult<A> in
        guard case .success(let result) = p.parse(input),
            case .success(let result2) = q.parse(result.remainder) else { return .failure(ParserError.error) }
        
        return .success(Parsed(remainder: result2.remainder, value: result.value))
    }
}

/**
 sequence actions, discarding left (value of the first argument)
 
 Expected function type: `f a -> f b -> f b`
 Haskell `infixl 4`
 */
func *> <A, B>(p: Parser<A>, q: Parser<B>) -> Parser<B> {
    return Parser<B> { (input: Data) -> ParserResult<B> in
        return p.parse(input).flatMap { result in
            return q.parse(result.remainder)
        }
    }
}
