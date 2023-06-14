//
//  ToNeverTests.swift
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
class ToNeverTests: XCTestCase {
    private enum `Error`: Swift.Error {
        case generalError
    }

    private var cancellables = Set<AnyCancellable>()

    func testToNeverWithCompletion() {
        let errorExpectation = XCTestExpectation()
        errorExpectation.isInverted = true
        let finishedExpectation = XCTestExpectation(description: "Should finish")
        var results = [String]()
        let subject = PassthroughSubject<String, Error>()

        subject
            .toNever(completeImmediately: true)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: finishedExpectation.fulfill()
                case .failure: errorExpectation.fulfill()
                }
            }, receiveValue: { value in
                results.append(value)
            })
            .store(in: &cancellables)

        subject.send("one")
        subject.send("two")
        subject.send(completion: .failure(Error.generalError))

        wait(for: [errorExpectation, finishedExpectation], timeout: 1)
        XCTAssertEqual(results, ["one", "two"])
    }

    func testToNverWithNoCompletion() {
        let errorExpectation = XCTestExpectation()
        errorExpectation.isInverted = true
        let finishedExpectation = XCTestExpectation()
        finishedExpectation.isInverted = true

        var results = [String]()
        let subject = PassthroughSubject<String, Error>()

        subject
            .toNever(completeImmediately: false)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: finishedExpectation.fulfill()
                case .failure: errorExpectation.fulfill()
                }
            }, receiveValue: { value in
                results.append(value)
            })
            .store(in: &cancellables)

        subject.send("one")
        subject.send("two")
        subject.send(completion: .failure(Error.generalError))

        wait(for: [errorExpectation, finishedExpectation], timeout: 1)
        XCTAssertEqual(results, ["one", "two"])
    }

    override func tearDown() {
        cancellables.removeAll()
    }
}
#endif
