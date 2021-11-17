//
//  NumberCompactorTests.swift
//
// Copyright 2021 FlowAllocator LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import XCTest

@testable import Compactor

class NumberCompactorTests: XCTestCase {

    func testExample() {
        let c = TimeCompactor(style: .full)
        XCTAssertEqual("14.3 days", c.string(from: 1_234_567))
    }
    
    func testBlankIfZero() {
        let c = NumberCompactor(blankIfZero: true)
        
        XCTAssertEqual("", c.string(from: 0))
        XCTAssertEqual("", c.string(from: 0.05))
        XCTAssertEqual("", c.string(from: -0.05))

        XCTAssertEqual("0.1", c.string(from: 0.051))
        XCTAssertEqual("-0.1", c.string(from: -0.051))
    }
    
    func testWholeNumber() {
        let c = NumberCompactor()
        c.roundSmallToWhole = true
        
        XCTAssertEqual("8", c.string(from: 8))
        XCTAssertEqual("-8", c.string(from: -8))
        
        XCTAssertEqual("10", c.string(from: 10))
        XCTAssertEqual("-10", c.string(from: -10))

        XCTAssertEqual("10", c.string(from: 10.1))
        XCTAssertEqual("-10", c.string(from: -10.1))

        XCTAssertEqual("99", c.string(from: 99.49))
        XCTAssertEqual("-99", c.string(from: -99.49))

        XCTAssertEqual("100", c.string(from: 99.50))
        XCTAssertEqual("-100", c.string(from: -99.50))

        XCTAssertEqual("999", c.string(from: 999))
        
        XCTAssertEqual("999", c.string(from: 999.49))
        XCTAssertEqual("-999", c.string(from: -999.49))
        
        XCTAssertEqual("1.0k", c.string(from: 999.50))
        XCTAssertEqual("-1.0k", c.string(from: -999.50))

        XCTAssertEqual("1.0k", c.string(from: 999.51))
        XCTAssertEqual("-1.0k", c.string(from: -999.51))

        XCTAssertEqual("1.0k", c.string(from: 999.95))
        XCTAssertEqual("-1.0k", c.string(from: -999.95))

        XCTAssertEqual("1.0k", c.string(from: 1000))
        XCTAssertEqual("-1.0k", c.string(from: -1000))
        
        XCTAssertEqual("999k", c.string(from: 999_000))
        XCTAssertEqual("-999k", c.string(from: -999_000))
     
        XCTAssertEqual("999k", c.string(from: 999_499))
        XCTAssertEqual("-999k", c.string(from: -999_499))

        XCTAssertEqual("1.0M", c.string(from: 999_500))
        XCTAssertEqual("-1.0M", c.string(from: -999_500))

        XCTAssertEqual("1.0M", c.string(from: 999_999.50))
        XCTAssertEqual("-1.0M", c.string(from: -999_999.50))
    }
    
    func testSmallValues() {
        let c = NumberCompactor(blankIfZero: false)

        XCTAssertEqual("0.0", c.string(from: 0))
        XCTAssertEqual("0.0", c.string(from: 0.05))
        XCTAssertEqual("0.0", c.string(from: -0.05))

        XCTAssertEqual("0.1", c.string(from: 0.051))
        XCTAssertEqual("-0.1", c.string(from: -0.051))

        XCTAssertEqual("0.1", c.string(from: 0.06))
        XCTAssertEqual("-0.1", c.string(from: -0.06))

        XCTAssertEqual("0.1", c.string(from: 0.1))
        XCTAssertEqual("-0.1", c.string(from: -0.1))
        
        XCTAssertEqual("1.1", c.string(from: 1.051))
        XCTAssertEqual("-1.1", c.string(from: -1.051))

        XCTAssertEqual("8.0", c.string(from: 8))
        XCTAssertEqual("-8.0", c.string(from: -8))

        XCTAssertEqual("10.1", c.string(from: 10.051))
        XCTAssertEqual("-10.1", c.string(from: -10.051))
    }
    
    func testK() {
        let c = NumberCompactor(blankIfZero: false)

        XCTAssertEqual("1.0k", c.string(from: 1_000))
        XCTAssertEqual("1.0k", c.string(from: 1_050.00000))
        XCTAssertEqual("1.1k", c.string(from: 1_050.00001))

        XCTAssertEqual("10.0k", c.string(from: 10_000))
        XCTAssertEqual("10.0k", c.string(from: 10_000.00001))
        XCTAssertEqual("10.0k", c.string(from: 10_050.00000))
        XCTAssertEqual("10.1k", c.string(from: 10_050.00001))

        XCTAssertEqual("90.0k", c.string(from: 90_000))
        XCTAssertEqual("99.0k", c.string(from: 99_000))

        XCTAssertEqual("99.5k", c.string(from: 99_500))
        XCTAssertEqual("99.5k", c.string(from: 99_549))

        XCTAssertEqual("99.6k", c.string(from: 99_550))

        XCTAssertEqual("99.9k", c.string(from: 99_900))
        XCTAssertEqual("99.9k", c.string(from: 99_949.99999))

        XCTAssertEqual("100k", c.string(from: 99_950.00000))
        XCTAssertEqual("100k", c.string(from: 99_999.50000))
        XCTAssertEqual("100k", c.string(from: 99_999.50001))

        XCTAssertEqual("100k", c.string(from: 100_000))
        XCTAssertEqual("100k", c.string(from: 100_000.00001))
        XCTAssertEqual("100k", c.string(from: 100_050.00000))
        XCTAssertEqual("100k", c.string(from: 100_050.00001))
        
        XCTAssertEqual("100k", c.string(from: 100_500.00000))
        XCTAssertEqual("101k", c.string(from: 100_500.00001))
    }
    
    func testM() {
        let c = NumberCompactor(blankIfZero: false)

        XCTAssertEqual("1.0M", c.string(from: 1_000_000))
        XCTAssertEqual("1.0M", c.string(from: 1_050_000.00000))
        XCTAssertEqual("1.1M", c.string(from: 1_050_000.00001))

        XCTAssertEqual("10.0M", c.string(from: 10_000_000))
        XCTAssertEqual("10.0M", c.string(from: 10_000_000.00001))
        XCTAssertEqual("10.0M", c.string(from: 10_050_000.00000))
        XCTAssertEqual("10.1M", c.string(from: 10_050_000.00001))

        XCTAssertEqual("90.0M", c.string(from: 90_000_000))
        XCTAssertEqual("99.0M", c.string(from: 99_000_000))

        XCTAssertEqual("99.5M", c.string(from: 99_500_000))
        XCTAssertEqual("99.5M", c.string(from: 99_549_999))

        XCTAssertEqual("99.6M", c.string(from: 99_550_000))

        XCTAssertEqual("99.9M", c.string(from: 99_900_000))
        XCTAssertEqual("99.9M", c.string(from: 99_949_999.99999))

        XCTAssertEqual("100M", c.string(from: 99_950_000.00000))
        XCTAssertEqual("100M", c.string(from: 99_999_999.50000))
        XCTAssertEqual("100M", c.string(from: 99_999_999.50001))

        XCTAssertEqual("100M", c.string(from: 100_000_000))
        XCTAssertEqual("100M", c.string(from: 100_000_000.00001))
        XCTAssertEqual("100M", c.string(from: 100_050_000.00000))
        XCTAssertEqual("100M", c.string(from: 100_050_000.00001))
        
        XCTAssertEqual("100M", c.string(from: 100_500_000.00000))
        XCTAssertEqual("101M", c.string(from: 100_500_000.00001))
    }
    
    func testG() {
        let c = NumberCompactor(blankIfZero: false)
        XCTAssertEqual("1.0G", c.string(from: 1_000_000_000))
        XCTAssertEqual("1.0G", c.string(from: 1_000_000_000.000001))
        XCTAssertEqual("1.0G", c.string(from: 1_050_000_000.000000))
        XCTAssertEqual("1.1G", c.string(from: 1_050_000_000.000001))
    }
    
    func testT() {
        let c = NumberCompactor(blankIfZero: false)
        XCTAssertEqual("1.0T", c.string(from: 1_000_000_000_000))
        XCTAssertEqual("1.0T", c.string(from: 1_000_000_000_000.001))
        XCTAssertEqual("1.0T", c.string(from: 1_050_000_000_000.000))
        XCTAssertEqual("1.1T", c.string(from: 1_050_000_000_000.001))
    }
    
    func testP() {
        let c = NumberCompactor(blankIfZero: false)
        XCTAssertEqual("1.0P", c.string(from: 1_000_000_000_000_000))
        XCTAssertEqual("1.0P", c.string(from: 1_000_000_000_000_000))
        XCTAssertEqual("1.0P", c.string(from: 1_050_000_000_000_000))
        XCTAssertEqual("1.1P", c.string(from: 1_050_000_000_000_001))
    }

    func testE() {
        let c = NumberCompactor(blankIfZero: false)
        XCTAssertEqual("1.0E", c.string(from: 1_000_000_000_000_000_000))
        XCTAssertEqual("1.0E", c.string(from: 1_000_000_000_000_000_000))
        XCTAssertEqual("1.0E", c.string(from: 1_050_000_000_000_000_000))
        XCTAssertEqual("1.1E", c.string(from: 1_050_000_000_000_001_000))
    }
}
