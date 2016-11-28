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
    return Parser<B> { (input) -> ParserResult<B> in
        return p.parse(input).flatMap { result1 in
            return q.parse(result1.remainder).map { result2 in
                return Parsed(remainder: result2.remainder, value: result1.value(result2.value))
            }
        }
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
        return p.parse(input).flatMap { result1 in
            return q.parse(result1.remainder).map { result2 in
                return Parsed(remainder: result2.remainder, value: result1.value)
            }
        }
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
