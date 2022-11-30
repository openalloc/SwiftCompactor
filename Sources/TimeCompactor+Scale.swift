//
//  TimeCompactor+Scale.swift
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

import Foundation

extension TimeCompactor {
    public enum Scale {
        case second
        case minute
        case hour
        case day
        case year
        case century
        case millenium
        
        var extent: TimeInterval {
            switch self {
            case .second:
                return 1
            case .minute:
                return 60
            case .hour:
                return 60 * 60
            case .day:
                return 86_400 // 24 * 60 * 60
            case .year:
                return 31_557_600 // 365.25 * 86400
            case .century:
                return 100 * 31_557_600
            case .millenium:
                return 1000 * 31_557_600
            }
        }
        
        // shortest possible, with no plural form
        var shortAbbreviation: String {
            switch self {
            case .second:
                return "s"
            case .minute:
                return "m"
            case .hour:
                return "h"
            case .day:
                return "d"
            case .year:
                return "y"
            case .century:
                return "c"
            case .millenium:
                return "ky"
            }
        }
                
        // usually longer than short, at most 4-5 chars, and may require plural form
        var mediumSingular: String {
            switch self {
            case .second:
                return "sec"
            case .minute:
                return "min"
            case .hour:
                return "hr"
            case .day:
                return "day"
            case .year:
                return "yr"
            case .century:
                return "cent"
            case .millenium:
                return "ky"
            }
        }

        var mediumPlural: String {
            switch self {
            case .second:
                return "secs"
            case .minute:
                return "mins"
            case .hour:
                return "hrs"
            case .day:
                return "days"
            case .year:
                return "yrs"
            case .century:
                return "cents"
            case .millenium:
                return "kys"
            }
        }

        var fullSingular: String {
            switch self {
            case .second:
                return "second"
            case .minute:
                return "minute"
            case .hour:
                return "hour"
            case .day:
                return "day"
            case .year:
                return "year"
            case .century:
                return "century"
            case .millenium:
                return "millennium"
            }
        }
        
        var fullPlural: String {
            switch self {
            case .second:
                return "seconds"
            case .minute:
                return "minutes"
            case .hour:
                return "hours"
            case .day:
                return "days"
            case .year:
                return "years"
            case .century:
                return "centuries"
            case .millenium:
                return "millenia"
            }
        }
    }
}
