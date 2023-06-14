//
//  Unwrap.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 05..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Combine

extension Publisher {
    /// Removes every nil values and republishes non-nil elements to the downstream subscriber.
    ///
    /// - returns: A non-nil publishing publisher.
    public func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == T? {
        compactMap { $0 }
    }

    /// Republishes every non-nil values to the downstream subscriber and throws and error at the first nil value.
    ///
    /// - parameter error: The error which thrown at the nil-value.
    ///
    /// - returns: A non-nil publishing publisher.
    public func unwrap<T>(orThrow error: @escaping @autoclosure () -> Failure) -> Publishers.TryMap<Self, T>
    where Output == T? {
        tryMap { output in
            switch output {
            case .some(let value):
                return value
            case nil:
                throw error()
            }
        }
    }

    /// Wraps every received value to an optional.
    ///
    /// - returns: An optional publishing publisher.
    public func wrap<T>() -> Publishers.Map<Self, T?> where Output == T {
        map { Optional($0) }
    }
}
#endif
