//
//  ToVoidTests.swift
//  SCCombineExtensions
//
//  Created by Barna Nemeth on 2023. 06. 06..
//  Copyright © 2023. Supercharge Ltd. All rights reserved.
//

#if !os(watchOS)
import XCTest
import Combine
import SCCombineExtensions

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class ToVoidTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testToVoid() throws {
        let stringSubject = CurrentValueSubject<String, Error>("one")
        let intSubject = CurrentValueSubject<Int, Error>(1)
        let nilSubject = CurrentValueSubject<Any?, Error>(nil)

        let stringResult = try awaitPublisher(stringSubject.toVoid().map { $0 as Any })
        let intResult = try awaitPublisher(intSubject.toVoid().map { $0 as Any })
        let nilResult = try awaitPublisher(nilSubject.toVoid().map { $0 as Any })

        XCTAssertTrue(stringResult is Void)
        XCTAssertTrue(intResult is Void)
        XCTAssertTrue(nilResult is Void)
    }

    override func tearDown() {
        cancellables.removeAll()
    }
}
#endif
