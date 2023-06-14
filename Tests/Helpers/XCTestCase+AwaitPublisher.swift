//
//  XCTestCase+AwaitPublisher.swift
//  
//
//  Created by Barna Nemeth on 2023. 06. 07..
//

#if canImport(Combine)
import Combine
import XCTest

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }

    func awaitAndCollectPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        maxOutputCount: Int = 3
    ) throws -> [T.Output] {
        var outputs = [T.Output]()
        var result: Result<[T.Output], Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        var cancellable: AnyCancellable?
        cancellable = publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error): result = .failure(error)
                case .finished: break
                }
                expectation.fulfill()
            }, receiveValue: { value in
                outputs.append(value)
                if outputs.count >= maxOutputCount {
                    expectation.fulfill()
                    cancellable?.cancel()
                }
            })

        waitForExpectations(timeout: timeout)
        cancellable?.cancel()

        let finalResult = result ?? .success(outputs)
        return try finalResult.get()
    }
}
#endif
