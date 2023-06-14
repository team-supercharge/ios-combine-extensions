//
//  AssignOwnership.swift
//  CombineExt
//
//  Created by Dmitry Kuznetsov on 08/05/2020.
//  Copyright © 2020 Combine Community. All rights reserved.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Failure == Never {
    /// Assigns a publisher’s output to a property of an object.
    ///
    /// - parameter keyPath: A key path that indicates the property to assign.
    /// - parameter object: The object that contains the property.
    ///                     The subscriber assigns the object’s property every time
    ///                     it receives a new value.
    /// - parameter ownership: The retainment / ownership strategy for the object, defaults to `strong`.
    ///
    /// - returns: An AnyCancellable instance. Call cancel() on this instance when you no longer want
    ///            the publisher to automatically assign the property. Deinitializing this instance
    ///            will also cancel automatic assignment.
    public func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
                                        on object: Root,
                                        ownership: ObjectOwnership = .strong) -> AnyCancellable {
        switch ownership {
        case .strong:
            return assign(to: keyPath, on: object)
        case .weak:
            return sink { [weak object] value in
                object?[keyPath: keyPath] = value
            }
        case .unowned:
            return sink { [unowned object] value in
                object[keyPath: keyPath] = value
            }
        }
    }
}
#endif
