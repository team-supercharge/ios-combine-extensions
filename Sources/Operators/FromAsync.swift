//
//  FromAsync.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 06..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Foundation
import Combine

extension Publishers {
    /// Converts an async/await method to a single value emiting publisher.
    ///
    /// - parameter async: The convertable async method.
    ///
    /// - returns: A publisher emitting the return value of the async method.
    public static func fromAsync<T>(_ async: @escaping () async throws -> T) -> AnyPublisher<T, Error> {
        var task: Task<Void, Never>?
        return Deferred {
            Future<T, Error> { promise in
                task = Task {
                    do {
                        let result = try await async()
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }.handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
}
#endif
