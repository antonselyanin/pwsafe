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
// Applicative sequential application
func <*> <A, B>(p: Parser<(A) -> B>, q: Parser<A>) -> Parser<B> {
    return Parser<B> { (input) -> (Data, B)? in
        guard let (inp, out) = p.parse(input),
            let (inp2, out2) = q.parse(inp) else { return nil }
        
        return (inp2, out(out2))
    }
}


/**
 sequence actions, discarding right (value of the second argument)
 
 Expected function type: `f a -> f b -> f a`
 Haskell `infixl 4`
 */
func <* <A, B>(p: Parser<A>, q: Parser<B>) -> Parser<A> {
    return Parser<A> { (input: Data) -> ParserResult<A> in
        guard let result = p.parse(input),
            let result2 = q.parse(result.remainder) else { return nil }
        
        return (result2.remainder, result.parsed)
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
