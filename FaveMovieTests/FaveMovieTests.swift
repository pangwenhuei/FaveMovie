//
//  FaveMovieTests.swift
//  FaveMovieTests
//
//  Created by TTHQ23-PANGWENHUEI on 14/11/2023.
//

import XCTest
@testable import FaveMovie

final class FaveMovieTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try testListingState()
        try testMovieDetailState()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testListingState() throws {
        let expectation = XCTestExpectation.init(description: "Received movie list")
        NetworkManager.shared.fetchListing { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Fail")
            }
            self.waitForExpectations(timeout: 20)
        }
    }
    
    //75780
    func testMovieDetailState() throws {
        let expectation = XCTestExpectation.init(description: "Received movie detail")
        NetworkManager.shared.fetchDetail(id: 75780) { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Fail")
            }
            self.waitForExpectations(timeout: 20)
        }
    }
}
