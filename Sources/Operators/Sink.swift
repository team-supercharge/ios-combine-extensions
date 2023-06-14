//
//  Sink.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 05..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Combine

extension Publisher {
    /// A variation of [sink()](https://developer.apple.com/documentation/combine/just/sink(receivecompletion:receivevalue:))
    /// that ignores the receiveCompletion and the receiveValue closures.
    ///
    /// - returns: An AnyCancellable instance
    public func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}

extension Publisher where Output == Never {
    /// A variation of [sink()](https://developer.apple.com/documentation/combine/just/sink(receivecompletion:receivevalue:))
    /// that ignores the receiveValue closure.
    ///
    /// - returns: An AnyCancellable instance
    public func sink(_ receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void) -> AnyCancellable {
        sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }
}

extension Publisher where Failure: Error {
    /// A variation of [sink()](https://developer.apple.com/documentation/combine/just/sink(receivecompletion:receivevalue:))
    /// that ignores the receiveCompletion closure.
    ///
    /// - returns: An AnyCancellable instance
    public func sink(_ receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
    }
}
#endif
