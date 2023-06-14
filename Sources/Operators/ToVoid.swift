//
//  ToVoid.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 05..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Combine

extension Publisher {
    /// Transforms every type of output to Void
    ///
    /// - returns: A publisher that has a Void output type.
    public func toVoid() -> AnyPublisher<Void, Failure> {
        map { _ in }.eraseToAnyPublisher()
    }
}
#endif
