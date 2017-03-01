//
//  GitHubUsersViewerTests.swift
//  GitHubUsersViewerTests
//
//  Created by Hank on 15/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import GitHubUsersViewer

class GitHubUsersViewerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUserSerializerSuccess() {
        let data: [String : Any] = ["id": 123456,
                                   "login": "foo",
                                   "avatar_url": "http://test.org/test.img"]
        let json = JSON.init(data)
        let user: User? = User(json: json)
        XCTAssert(user != nil)
        XCTAssert(user?.id == 123456)
        XCTAssert(user?.userName == "foo")
        XCTAssert(user?.avatarURL == "http://test.org/test.img")
    }

    func testUserSerializerFailure() {
        let data: [String : Any] = ["id": "foo",
                                    "avatar_url": "http://test.org/test.img"]
        let json = JSON.init(data)
        let user: User? = User(json: json)
        XCTAssert(user == nil)
    }

    func testUserDetailSerializerSuccess() {
        let data: [String : Any] = ["public_repos": 30,
                                    "followers": 0,
                                    "following": 100,
                                    "name": "Saber",
                                    "company": "Avalon"]
        let json = JSON.init(data)
        let userDetail: UserDetail? = UserDetail(json: json)
        XCTAssert(userDetail != nil)
        XCTAssert(userDetail?.userName == "Saber")
        XCTAssert(userDetail?.companyName == "Avalon")
        XCTAssert(userDetail?.publicRepos == 30)
        XCTAssert(userDetail?.followers == 0)
        XCTAssert(userDetail?.followings == 100)
    }

    func testUserDetailSerializerFailure() {
        let data: [String : Any] = ["public_repos": 30,
                                    "following": 100,
                                    "name": [],
                                    "company": "Avalon"]
        let json = JSON.init(data)
        let userDetail: UserDetail? = UserDetail(json: json)
        XCTAssert(userDetail == nil)
    }

}
