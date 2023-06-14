//
//  Just+Void.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 05..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Combine

extension Just where Output == Void {
    public static func void<F>() -> AnyPublisher<Void, F> where F: Error {
        Just(()).setFailureType(to: F.self).eraseToAnyPublisher()
    }
}
#endif
