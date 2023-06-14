//
//  ShareReplay.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 05..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Combine

extension Publisher {
    /// A variation of [share()](https://developer.apple.com/documentation/combine/publisher/3204754-share)
    /// that holds the previously emited value and emits it to future subscribers.
    ///
    /// - returns: A publisher that replays the last value to future subscribers.
    public func shareReplay() -> AnyPublisher<Output, Failure> {
        map { Optional($0) }
        .multicast { CurrentValueSubject(Optional.none) }
        .autoconnect()
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
}
#endif
