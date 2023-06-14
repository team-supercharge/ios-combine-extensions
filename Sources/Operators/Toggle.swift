//
//  Toggle.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 06..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//


#if canImport(Combine)
import Combine

extension Publisher where Output == Bool {
    /// Toggles boolean values emitted by a publisher.
    ///
    /// - returns: A toggled value.
    public func toggle() -> AnyPublisher<Output, Failure> {
        map { !$0 }.eraseToAnyPublisher()
    }
}
#endif
