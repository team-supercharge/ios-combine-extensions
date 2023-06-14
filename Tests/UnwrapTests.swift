//
//  UnwrapTests.swift
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
class UnwrapTests: XCTestCase {
    private enum `Error`: Swift.Error {
        case nilError
    }

    private var cancellables = Set<AnyCancellable>()

    func testUnwrap() {
        var results = [String]()
        let subject = PassthroughSubject<String?, Error>()

        subject
            .unwrap()
            .sink { results.append($0) }
            .store(in: &cancellables)

        subject.send("one")
        subject.send(nil)
        subject.send(nil)
        subject.send("two")
        subject.send("three")
        subject.send(nil)

        XCTAssertEqual(results, ["one", "two", "three"])
    }


    func testUnwrapOrThrow() {
        let errorExpectation = XCTestExpectation(description: "Error should be UnwrapTests.Error.nilError")
        var results = [String]()
        let subject = PassthroughSubject<String?, Error>()

        subject
            .unwrap(orThrow: Error.nilError)
            .sink(receiveCompletion: { completion in
                guard case let .failure(error) = completion,
                      let testError = error as? Error,
                      .nilError == testError else { return }
                errorExpectation.fulfill()
            }, receiveValue: { value in
                results.append(value)
            })
            .store(in: &cancellables)

        subject.send("one")
        subject.send("two")
        subject.send(nil)
        subject.send(nil)
        subject.send("three")
        subject.send(nil)

        wait(for: [errorExpectation], timeout: 1)
        XCTAssertEqual(results, ["one", "two"])
    }

    override func tearDown() {
        cancellables.removeAll()
    }
}
#endif
