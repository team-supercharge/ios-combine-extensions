//
//  ShareReplayTests.swift
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
class ShareReplayTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    private let nonOptionalSubject = PassthroughSubject<String, Error>()
    private lazy var nonOptionalPublisher: AnyPublisher<String, Error> = {
        nonOptionalSubject.shareReplay()
    }()

    private let optionalSubject = PassthroughSubject<String?, Error>()
    private lazy var optionalPublisher: AnyPublisher<String?, Error> = {
        optionalSubject.shareReplay()
    }()

    private let collectionSubject = PassthroughSubject<[String], Error>()
    private lazy var collectionPublisher: AnyPublisher<[String], Error> = {
        collectionSubject.shareReplay()
    }()

    override func setUp() {
        nonOptionalPublisher.sink().store(in: &cancellables)
        optionalPublisher.sink().store(in: &cancellables)
        collectionPublisher.sink().store(in: &cancellables)
    }

    func testNonOptionalShareReplay() throws {
        nonOptionalSubject.send("one")
        nonOptionalSubject.send("two")

        let result = try awaitPublisher(nonOptionalPublisher, timeout: 1)
        XCTAssertEqual(result, "two")
    }

    func testOptionalShareReplay() throws {
        optionalSubject.send(nil)
        optionalSubject.send("one")
        optionalSubject.send("two")
        optionalSubject.send(nil)

        let result = try awaitPublisher(optionalPublisher, timeout: 1)
        XCTAssertEqual(result, nil)
    }

    func collectionShareReplay() throws {
        collectionSubject.send([])
        collectionSubject.send(["one", "two", "three"])

        let result = try awaitPublisher(collectionSubject, timeout: 1)
        XCTAssertEqual(result, ["one", "two", "three"])
    }

    override func tearDown() {
        cancellables.removeAll()
    }
}
#endif
