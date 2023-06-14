//
//  ToggleTests.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 07..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if !os(watchOS)
import XCTest
import Combine
import SCCombineExtensions

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class ToggleTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testToggle() throws {
        let trueSubject = CurrentValueSubject<Bool, Error>(true)
        let falseSubject = CurrentValueSubject<Bool, Error>(false)

        XCTAssertEqual(try awaitPublisher(trueSubject.toggle()), false)
        XCTAssertEqual(try awaitPublisher(falseSubject.toggle()), true)
    }

    override func tearDown() {
        cancellables.removeAll()
    }
}
#endif
