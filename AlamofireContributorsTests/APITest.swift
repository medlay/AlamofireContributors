//
//  APITest.swift
//  AlamofireContributorsTests
//
//  Created by Vasyl Skrypij on 3/3/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import XCTest
@testable import AlamofireContributors

class APITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatItDownloadsUserlist() {
        let expectation = XCTestExpectation(description: "Download users list")
        APIManager.sharedInstance.contributorsList(page: 0) { result in
            switch result {
            case .success(let users):
                XCTAssertTrue(users.count > 0)
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testThatItDownloadsUserInfo() {
        let expectation = XCTestExpectation(description: "Download user info")
        APIManager.sharedInstance.userInfo(login: "medlay") { result in
            switch result {
            case .success(let user):
                XCTAssertTrue(user.login.count > 0)
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}
