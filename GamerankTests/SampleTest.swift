//
//  SampleTest.swift
//  GamerankTests
//
//  Created by Fadhil Ikhsanta on 09/01/23.
//

import XCTest
@testable import Gamerank
final class SampleTest: XCTestCase {

    func testExample() throws {
        XCTAssertEqual(true, getBool())
    }
    
    func getBool() -> Bool {
        return true
    }
}
