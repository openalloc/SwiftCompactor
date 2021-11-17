//
//  CurrencyCompactorTests.swift
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

class CurrencyCompactorTests: XCTestCase {

    func testBlankIfZero() {
        let c = CurrencyCompactor(blankIfZero: true)
        c.currencyCode = "USD"
        c.decimalSeparator = "."

        XCTAssertEqual("", c.string(from: 0))
        XCTAssertEqual("", c.string(from: 0.05))
        XCTAssertEqual("", c.string(from: -0.05))

        XCTAssertEqual("", c.string(from: 0.051))
        XCTAssertEqual("", c.string(from: -0.051))

        XCTAssertEqual("", c.string(from: 0.49))
        XCTAssertEqual("", c.string(from: -0.49))

        XCTAssertEqual("", c.string(from: 0.50))
        XCTAssertEqual("", c.string(from: -0.50))

        XCTAssertEqual("$1", c.string(from: 0.51))
        XCTAssertEqual("-$1", c.string(from: -0.51))

        XCTAssertEqual("$1", c.string(from: 0.95))
        XCTAssertEqual("-$1", c.string(from: -0.95))
    }

    func testCompactDropTrailingDotZero() {
        let c = CurrencyCompactor(blankIfZero: false)
        c.currencyCode = "USD"
        c.decimalSeparator = "."

        XCTAssertEqual("$12", c.string(from: 12.049))
        XCTAssertEqual("-$12", c.string(from: -12.0500000))
        XCTAssertEqual("-$12", c.string(from: -12.0500001))
    }

    func testCompactUS() {
        let c = CurrencyCompactor(blankIfZero: false)
        c.currencyCode = "USD"
        
        XCTAssertEqual("-$121T", c.string(from: -120_500_000_000_000.01))
        XCTAssertEqual("-$120T", c.string(from: -120_500_000_000_000.00))

        XCTAssertEqual("-$121G", c.string(from: -120_500_000_000.01))
        XCTAssertEqual("-$120G", c.string(from: -120_500_000_000.00))

        XCTAssertEqual("-$121M", c.string(from: -120_500_000.01))
        XCTAssertEqual("-$120M", c.string(from: -120_500_000.00))

        XCTAssertEqual("-$121k", c.string(from: -120_500.01))
        XCTAssertEqual("-$120k", c.string(from: -120_500.00))

        XCTAssertEqual("-$12.1k", c.string(from: -12050.01))
        XCTAssertEqual("-$12.0k", c.string(from: -12050.00))

        XCTAssertEqual("-$121", c.string(from: -120.51))
        XCTAssertEqual("-$120", c.string(from: -120.50))

        XCTAssertEqual("-$12", c.string(from: -12.051))
        XCTAssertEqual("-$12", c.string(from: -12.050))

        XCTAssertEqual("-$2", c.string(from: -1.5))
        XCTAssertEqual("-$1", c.string(from: -1.49))
        XCTAssertEqual("-$1", c.string(from: -1.250))

        XCTAssertEqual("$0", c.string(from: -0.251))
        XCTAssertEqual("$0", c.string(from: -0.250))
        XCTAssertEqual("$0", c.string(from: -0.051))
        XCTAssertEqual("$0", c.string(from: -0.050))
        XCTAssertEqual("$0", c.string(from: 0.000))
        XCTAssertEqual("$0", c.string(from: 0.050))
        XCTAssertEqual("$0", c.string(from: 0.051))
        XCTAssertEqual("$0", c.string(from: 0.250))
        XCTAssertEqual("$0", c.string(from: 0.251))
        XCTAssertEqual("$0", c.string(from: 0.499))
        XCTAssertEqual("$0", c.string(from: 0.500))

        XCTAssertEqual("$1", c.string(from: 0.501))
        XCTAssertEqual("$1", c.string(from: 1.49))
        XCTAssertEqual("$2", c.string(from: 1.5))

        XCTAssertEqual("$12", c.string(from: 12.050))
        XCTAssertEqual("$12", c.string(from: 12.051))

        XCTAssertEqual("$120", c.string(from: 120.50))
        XCTAssertEqual("$121", c.string(from: 120.51))

        XCTAssertEqual("$12.0k", c.string(from: 12050.00))
        XCTAssertEqual("$12.1k", c.string(from: 12050.01))

        XCTAssertEqual("$120k", c.string(from: 120_500.00))
        XCTAssertEqual("$121k", c.string(from: 120_500.01))

        XCTAssertEqual("$120M", c.string(from: 120_500_000.00))
        XCTAssertEqual("$121M", c.string(from: 120_500_000.01))

        XCTAssertEqual("$120G", c.string(from: 120_500_000_000.00))
        XCTAssertEqual("$121G", c.string(from: 120_500_000_000.01))

        XCTAssertEqual("$120T", c.string(from: 120_500_000_000_000.00))
        XCTAssertEqual("$121T", c.string(from: 120_500_000_000_000.01))
    }

    func testNormalEU() {

        let c = CurrencyCompactor(blankIfZero: false)
        c.locale = Locale(identifier: "FR")
        c.currencyCode = "EUR"
        
        XCTAssertEqual("-12,1k €", c.string(from: -12050.01))

        XCTAssertEqual("0 €", c.string(from: 0.2549))
        XCTAssertEqual("0 €", c.string(from: 0.2550))

        XCTAssertEqual("121k €", c.string(from: 120500.01))
    }

    func testCompactEU() {
        let c = CurrencyCompactor(blankIfZero: false)
        c.locale = Locale(identifier: "US")
        c.currencyCode = "EUR"
        c.currencyDecimalSeparator = ","

        XCTAssertEqual("-€12,1k", c.string(from: -12050.01))
        
        XCTAssertEqual("€0", c.string(from: 0.000))
        XCTAssertEqual("€0", c.string(from: 0.050))
        XCTAssertEqual("€0", c.string(from: 0.051))
        XCTAssertEqual("€0", c.string(from: 0.250))
        XCTAssertEqual("€0", c.string(from: 0.251))
        XCTAssertEqual("€1", c.string(from: 1.250))
        XCTAssertEqual("€1", c.string(from: 1.251))
        XCTAssertEqual("€12", c.string(from: 12.050))
        XCTAssertEqual("€12", c.string(from: 12.051))
        XCTAssertEqual("€120", c.string(from: 120.50))
        XCTAssertEqual("€121", c.string(from: 120.51))
        XCTAssertEqual("€12,0k", c.string(from: 12050.00))
        XCTAssertEqual("€12,1k", c.string(from: 12050.01))
        XCTAssertEqual("€120k", c.string(from: 120_500.00))
        XCTAssertEqual("€121k", c.string(from: 120_500.01))
        XCTAssertEqual("€120M", c.string(from: 120_500_000.00))
        XCTAssertEqual("€121M", c.string(from: 120_500_000.01))
        XCTAssertEqual("€120G", c.string(from: 120_500_000_000.00))
        XCTAssertEqual("€121G", c.string(from: 120_500_000_000.01))
        XCTAssertEqual("€120T", c.string(from: 120_500_000_000_000.00))
        XCTAssertEqual("€121T", c.string(from: 120_500_000_000_000.01))
    }
}
