//
//  TimeCompactorTests.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
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

class TimeCompactorTests: XCTestCase {
    func testBlankIfZero() {
        let c = TimeCompactor(ifZero: "", style: .short)

        XCTAssertEqual("", c.string(from: 0.049))
        XCTAssertEqual("", c.string(from: -0.049))

        XCTAssertEqual("", c.string(from: 0.050))
        XCTAssertEqual("", c.string(from: -0.050))

        XCTAssertEqual("0.1s", c.string(from: 0.051))
        XCTAssertEqual("-0.1s", c.string(from: -0.051))

        XCTAssertEqual("0.5s", c.string(from: 0.49))
        XCTAssertEqual("-0.5s", c.string(from: -0.49))

        XCTAssertEqual("0.5s", c.string(from: 0.50))
        XCTAssertEqual("-0.5s", c.string(from: -0.50))

        XCTAssertEqual("0.5s", c.string(from: 0.51))
        XCTAssertEqual("-0.5s", c.string(from: -0.51))

        XCTAssertEqual("12.0s", c.string(from: 12.049))
        XCTAssertEqual("-12.0s", c.string(from: -12.050))
    }

    func testWholeNumberMedium() {
        let c = TimeCompactor(ifZero: nil, style: .medium, roundSmallToWhole: true)

        XCTAssertEqual("59 secs", c.string(from: 59))
        XCTAssertEqual("59 secs", c.string(from: 59.499))
        XCTAssertEqual("1 min", c.string(from: 59.500))
        XCTAssertEqual("1 min", c.string(from: 59.899))
        XCTAssertEqual("1 min", c.string(from: 59.9))
        XCTAssertEqual("1 min", c.string(from: 60))
        XCTAssertEqual("1 min", c.string(from: 61))
        XCTAssertEqual("1 min", c.string(from: 89.499))
        XCTAssertEqual("1 min", c.string(from: 89.999))
        XCTAssertEqual("2 mins", c.string(from: 90))

        XCTAssertEqual("1 sec", c.string(from: 1))
        XCTAssertEqual("1 sec", c.string(from: 1.49))
        XCTAssertEqual("2 secs", c.string(from: 1.50))

        XCTAssertEqual("1 hr", c.string(from: 3600))
        XCTAssertEqual("1 hr", c.string(from: 5399)) // <1.5 hours
        XCTAssertEqual("2 hrs", c.string(from: 5400)) // 1.5 hours
    }

    func testWholeNumberFull() {
        let c = TimeCompactor(ifZero: nil, style: .full, roundSmallToWhole: true)

        XCTAssertEqual("59 seconds", c.string(from: 59))
        XCTAssertEqual("59 seconds", c.string(from: 59.499))
        XCTAssertEqual("1 minute", c.string(from: 59.500))
        XCTAssertEqual("1 minute", c.string(from: 59.899))
        XCTAssertEqual("1 minute", c.string(from: 59.9))
        XCTAssertEqual("1 minute", c.string(from: 60))
        XCTAssertEqual("1 minute", c.string(from: 61))
        XCTAssertEqual("1 minute", c.string(from: 89.499))
        XCTAssertEqual("1 minute", c.string(from: 89.999))
        XCTAssertEqual("2 minutes", c.string(from: 90))

        XCTAssertEqual("1 second", c.string(from: 1))
        XCTAssertEqual("1 second", c.string(from: 1.49))
        XCTAssertEqual("2 seconds", c.string(from: 1.50))

        XCTAssertEqual("1 hour", c.string(from: 3600))
        XCTAssertEqual("1 hour", c.string(from: 5399)) // <1.5 hours
        XCTAssertEqual("2 hours", c.string(from: 5400)) // 1.5 hours
    }

    func testWholeNumberShort() {
        let c = TimeCompactor(ifZero: nil, style: .short, roundSmallToWhole: true)

        XCTAssertEqual("59s", c.string(from: 59))
        XCTAssertEqual("59s", c.string(from: 59.499))
        XCTAssertEqual("1m", c.string(from: 59.500))
        XCTAssertEqual("1m", c.string(from: 59.899))
        XCTAssertEqual("1m", c.string(from: 59.9))
        XCTAssertEqual("1m", c.string(from: 60))
        XCTAssertEqual("1m", c.string(from: 61))
        XCTAssertEqual("1m", c.string(from: 89.499))
        XCTAssertEqual("1m", c.string(from: 89.999))
        XCTAssertEqual("2m", c.string(from: 90.000))

        XCTAssertEqual("1s", c.string(from: 1.00))
        XCTAssertEqual("1s", c.string(from: 1.49))
        XCTAssertEqual("2s", c.string(from: 1.50))

        XCTAssertEqual("1h", c.string(from: 3600))
        XCTAssertEqual("1h", c.string(from: 5399)) // <1.5 hours
        XCTAssertEqual("2h", c.string(from: 5400)) // 1.5 hours
    }

    func testPluralMedium() {
        let c = TimeCompactor(ifZero: nil, style: .medium)

        XCTAssertEqual("1.0 secs", c.string(from: 1))
        XCTAssertEqual("1.1 secs", c.string(from: 1.09))

        XCTAssertEqual("59.0 secs", c.string(from: 59))
        XCTAssertEqual("59.9 secs", c.string(from: 59.94))
        XCTAssertEqual("1.0 mins", c.string(from: 59.95))
        XCTAssertEqual("1.0 mins", c.string(from: 60))
        XCTAssertEqual("1.0 mins", c.string(from: 61))
        XCTAssertEqual("1.5 mins", c.string(from: 89))

        XCTAssertEqual("1.0 hrs", c.string(from: 3600))
        XCTAssertEqual("1.5 hrs", c.string(from: 5400))
        XCTAssertEqual("2.0 hrs", c.string(from: 7200))
    }

    func testPluralFull() {
        let c = TimeCompactor(ifZero: nil, style: .full)

        XCTAssertEqual("1.0 seconds", c.string(from: 1))
        XCTAssertEqual("1.1 seconds", c.string(from: 1.09))

        XCTAssertEqual("59.0 seconds", c.string(from: 59))
        XCTAssertEqual("59.9 seconds", c.string(from: 59.94))
        XCTAssertEqual("1.0 minutes", c.string(from: 59.95))
        XCTAssertEqual("1.0 minutes", c.string(from: 60))
        XCTAssertEqual("1.0 minutes", c.string(from: 61))
        XCTAssertEqual("1.5 minutes", c.string(from: 89))

        XCTAssertEqual("1.0 hours", c.string(from: 3600))
        XCTAssertEqual("1.5 hours", c.string(from: 5400))
        XCTAssertEqual("2.0 hours", c.string(from: 7200))
    }

    func testCompactDropTrailingDotZero() {
        let c = TimeCompactor(ifZero: nil, style: .short)

        XCTAssertEqual("12.0s", c.string(from: 12.049))
        XCTAssertEqual("-12.0s", c.string(from: -12.050))
    }

    func testShort() {
        let c = TimeCompactor(ifZero: nil, style: .short)

        XCTAssertEqual("-3818ky", c.string(from: -120_500_000_000_000))
        XCTAssertEqual("-3.8ky", c.string(from: -120_500_000_000))
        XCTAssertEqual("-3.3c", c.string(from: -10_500_000_000))
        XCTAssertEqual("-3.8y", c.string(from: -120_500_000))
        XCTAssertEqual("-1.4d", c.string(from: -120_500))
        XCTAssertEqual("-3.3h", c.string(from: -12050))
        XCTAssertEqual("-2.0m", c.string(from: -120.50))
        XCTAssertEqual("-12.0s", c.string(from: -12.050))

        XCTAssertEqual("-1.5s", c.string(from: -1.5))
        XCTAssertEqual("-1.5s", c.string(from: -1.49))
        XCTAssertEqual("-1.2s", c.string(from: -1.250))

        XCTAssertEqual("-0.3s", c.string(from: -0.251))
        XCTAssertEqual("-0.2s", c.string(from: -0.250))
        XCTAssertEqual("-0.1s", c.string(from: -0.051))
        XCTAssertEqual("0.0s", c.string(from: -0.050))
        XCTAssertEqual("0.0s", c.string(from: 0.000))
        XCTAssertEqual("0.0s", c.string(from: 0.050))
        XCTAssertEqual("0.1s", c.string(from: 0.051))
        XCTAssertEqual("0.2s", c.string(from: 0.250))
        XCTAssertEqual("0.3s", c.string(from: 0.251))
        XCTAssertEqual("0.5s", c.string(from: 0.499))
        XCTAssertEqual("0.5s", c.string(from: 0.500))

        XCTAssertEqual("0.5s", c.string(from: 0.501))
        XCTAssertEqual("1.5s", c.string(from: 1.49))
        XCTAssertEqual("1.5s", c.string(from: 1.5))

        XCTAssertEqual("12.0s", c.string(from: 12.050))
        XCTAssertEqual("12.1s", c.string(from: 12.051))

        XCTAssertEqual("2.0m", c.string(from: 120.50))
        XCTAssertEqual("2.0m", c.string(from: 120.51))

        XCTAssertEqual("3.3h", c.string(from: 12050))

        XCTAssertEqual("1.4d", c.string(from: 120_500))

        XCTAssertEqual("3.8y", c.string(from: 120_500_000))

        XCTAssertEqual("3.8ky", c.string(from: 120_500_000_000))

        XCTAssertEqual("3818ky", c.string(from: 120_500_000_000_000))
    }

    func testMedium() {
        let c = TimeCompactor(ifZero: nil, style: .medium)

        XCTAssertEqual("-3818 kys", c.string(from: -120_500_000_000_000))
        XCTAssertEqual("-3.8 kys", c.string(from: -120_500_000_000))
        XCTAssertEqual("-3.3 cents", c.string(from: -10_500_000_000))
        XCTAssertEqual("-3.8 yrs", c.string(from: -120_500_000))
        XCTAssertEqual("-1.4 days", c.string(from: -120_500))
        XCTAssertEqual("-3.3 hrs", c.string(from: -12050))
        XCTAssertEqual("-2.0 mins", c.string(from: -120.50))
        XCTAssertEqual("-12.0 secs", c.string(from: -12.050))

        XCTAssertEqual("-1.5 secs", c.string(from: -1.5))
        XCTAssertEqual("-1.5 secs", c.string(from: -1.49))
        XCTAssertEqual("-1.2 secs", c.string(from: -1.250))

        XCTAssertEqual("-0.3 secs", c.string(from: -0.251))
        XCTAssertEqual("-0.2 secs", c.string(from: -0.250))
        XCTAssertEqual("-0.1 secs", c.string(from: -0.051))
        XCTAssertEqual("0.0 secs", c.string(from: -0.050))
        XCTAssertEqual("0.0 secs", c.string(from: 0.000))
        XCTAssertEqual("0.0 secs", c.string(from: 0.050))
        XCTAssertEqual("0.1 secs", c.string(from: 0.051))
        XCTAssertEqual("0.2 secs", c.string(from: 0.250))
        XCTAssertEqual("0.3 secs", c.string(from: 0.251))
        XCTAssertEqual("0.5 secs", c.string(from: 0.499))
        XCTAssertEqual("0.5 secs", c.string(from: 0.500))

        XCTAssertEqual("0.5 secs", c.string(from: 0.501))
        XCTAssertEqual("1.5 secs", c.string(from: 1.49))
        XCTAssertEqual("1.5 secs", c.string(from: 1.5))

        XCTAssertEqual("12.0 secs", c.string(from: 12.050))
        XCTAssertEqual("12.1 secs", c.string(from: 12.051))

        XCTAssertEqual("2.0 mins", c.string(from: 120.50))
        XCTAssertEqual("2.0 mins", c.string(from: 120.51))

        XCTAssertEqual("3.3 hrs", c.string(from: 12050))

        XCTAssertEqual("1.4 days", c.string(from: 120_500))

        XCTAssertEqual("3.8 yrs", c.string(from: 120_500_000))

        XCTAssertEqual("3.8 kys", c.string(from: 120_500_000_000))

        XCTAssertEqual("3818 kys", c.string(from: 120_500_000_000_000))
    }

    func testFull() {
        let c = TimeCompactor(ifZero: nil, style: .full)

        XCTAssertEqual("-3818 millenia", c.string(from: -120_500_000_000_000))
        XCTAssertEqual("-3.8 millenia", c.string(from: -120_500_000_000))
        XCTAssertEqual("-3.3 centuries", c.string(from: -10_500_000_000))
        XCTAssertEqual("-3.8 years", c.string(from: -120_500_000))
        XCTAssertEqual("-1.4 days", c.string(from: -120_500))
        XCTAssertEqual("-3.3 hours", c.string(from: -12050))
        XCTAssertEqual("-2.0 minutes", c.string(from: -120.50))
        XCTAssertEqual("-12.0 seconds", c.string(from: -12.050))

        XCTAssertEqual("-1.5 seconds", c.string(from: -1.5))
        XCTAssertEqual("-1.5 seconds", c.string(from: -1.49))
        XCTAssertEqual("-1.2 seconds", c.string(from: -1.250))

        XCTAssertEqual("-0.3 seconds", c.string(from: -0.251))
        XCTAssertEqual("-0.2 seconds", c.string(from: -0.250))
        XCTAssertEqual("-0.1 seconds", c.string(from: -0.051))
        XCTAssertEqual("0.0 seconds", c.string(from: -0.050))
        XCTAssertEqual("0.0 seconds", c.string(from: 0.000))
        XCTAssertEqual("0.0 seconds", c.string(from: 0.050))
        XCTAssertEqual("0.1 seconds", c.string(from: 0.051))
        XCTAssertEqual("0.2 seconds", c.string(from: 0.250))
        XCTAssertEqual("0.3 seconds", c.string(from: 0.251))
        XCTAssertEqual("0.5 seconds", c.string(from: 0.499))
        XCTAssertEqual("0.5 seconds", c.string(from: 0.500))

        XCTAssertEqual("0.5 seconds", c.string(from: 0.501))
        XCTAssertEqual("1.5 seconds", c.string(from: 1.49))
        XCTAssertEqual("1.5 seconds", c.string(from: 1.5))

        XCTAssertEqual("12.0 seconds", c.string(from: 12.050))
        XCTAssertEqual("12.1 seconds", c.string(from: 12.051))

        XCTAssertEqual("2.0 minutes", c.string(from: 120.50))
        XCTAssertEqual("2.0 minutes", c.string(from: 120.51))

        XCTAssertEqual("3.3 hours", c.string(from: 12050))

        XCTAssertEqual("1.4 days", c.string(from: 120_500))

        XCTAssertEqual("3.8 years", c.string(from: 120_500_000))

        XCTAssertEqual("3.8 millenia", c.string(from: 120_500_000_000))

        XCTAssertEqual("3818 millenia", c.string(from: 120_500_000_000_000))
    }

    func testCompactEU() {
        let c = TimeCompactor(ifZero: nil, style: .short)
        c.decimalSeparator = ","

        XCTAssertEqual("3,3h", c.string(from: 12050))
    }
}
