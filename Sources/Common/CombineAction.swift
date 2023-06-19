//
//  CombineAction.swift
//  
//
//  Created by Kristof Zelei on 2023. 06. 19..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

import Combine
import Foundation

/// Typealias for compatibility with UIButton's action property.
public typealias CombineAction = Action<Void, Never>

public typealias CombineInputAction<T> = Action<T, Never>

extension CombineAction {
    public convenience init(_ defaultAction: (() -> Void)? = nil) {
        self.init { _ in
            defaultAction?()
        }
    }

    public convenience init<Object: AnyObject>(_ defaultAction: @escaping ((Object) -> () -> Void), in object: Object) {
        self.init { [weak object] _ in
            guard let object = object else { return }
            defaultAction(object)()
        }
    }

    @discardableResult public func execute() -> AnyPublisher<InputType, ErrorType> {
        subject.send(())

        return actionPublisher
    }
}

extension Action where ErrorType == Never {
    public convenience init<Object: AnyObject>( _ defaultAction: @escaping ((Object) -> (InputType) -> Void),
                                                in object: Object) {
        self.init { [weak object] result in
            guard let object = object else { return }
            guard case .success(let value) = result else { return }
            defaultAction(object)(value)
        }
    }
}

public final class Action<InputType, ErrorType: Error> {
    private let subject = PassthroughSubject<InputType, ErrorType>()
    private var cancellables = Set<AnyCancellable>()

    public var actionPublisher: AnyPublisher<InputType, ErrorType> {
        subject.eraseToAnyPublisher()
    }

    public init(_ defaultAction: ((Result<InputType, ErrorType>) -> Void)?) {
        guard let defaultAction = defaultAction else { return }
        actionPublisher.sink { completion in
            if case .failure(let error) = completion {
                defaultAction(.failure(error))
            }
        } receiveValue: { value in
            defaultAction(.success(value))
        }
        .store(in: &cancellables)
    }

    public convenience init<Object: AnyObject>(
        _ defaultAction: @escaping ((Object) -> (Result<InputType, ErrorType>) -> Void),
        in object: Object) {
        self.init { [weak object] result in
            guard let object = object else { return }
            defaultAction(object)(result)
        }
    }

    public init(firstAction: Action<InputType, ErrorType>, secondAction: Action<InputType, ErrorType>) {
        actionPublisher.sink { completion in
            if case .failure(let error) = completion {
                firstAction.execute(error)
                secondAction.execute(error)
            }
        } receiveValue: { value in
            firstAction.execute(value)
            secondAction.execute(value)
        }
        .store(in: &cancellables)
    }

    @discardableResult
    public func execute(
        _ closure: @autoclosure () -> Result<InputType, ErrorType>) -> AnyPublisher<InputType, ErrorType> {

        let result = closure()

        switch result {
        case .success(let value):
            subject.send(value)
        case .failure(let error):
            subject.send(completion: .failure(error))
        }

        return actionPublisher
    }

    @discardableResult
    public func execute(_ closure: @autoclosure () -> InputType) -> AnyPublisher<InputType, ErrorType> {
        execute(.success(closure()))
    }

    @discardableResult
    public func execute(_ closure: @autoclosure () -> ErrorType) -> AnyPublisher<InputType, ErrorType> {
        execute(.failure(closure()))
    }
}
