//
//  SkipErrors.swift
//  
//
//  Created by Kristof Zelei on 2023. 06. 20..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if canImport(Combine)
import Combine

extension Publisher where Failure == Error {
    public func skipErrors() -> AnyPublisher<Output, Never> {
        map { Optional($0) }
            .replaceError(with: nil)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
#endif
