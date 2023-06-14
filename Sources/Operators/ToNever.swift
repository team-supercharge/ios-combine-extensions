//
//  ToNever.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 06..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Combine

extension Publisher {
    /// Catches the error of the upstream and replaces it with an Empty publisher.
    ///
    /// - parameter completeImmediately: Whether the returned publisher should complete on an error event. Defaults to `true`.
    ///
    /// - returns: A publisher that ignores upstream error events.
    public func toNever(completeImmediately: Bool = true) -> AnyPublisher<Output, Never> {
        self.catch { error -> AnyPublisher<Output, Never> in
            return Empty(completeImmediately: completeImmediately, outputType: Output.self, failureType: Never.self)
                .eraseToAnyPublisher()
        }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
#endif
