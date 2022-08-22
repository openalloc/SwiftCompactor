//
//  NumberCompactor+Scale.swift
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

extension NumberCompactor {
    public enum Scale: Int, CaseIterable {
        case none = 0
        case kilo = 1
        case mega = 2
        case giga = 3
        case tera = 4
        case peta = 5
        case exa = 6
        
        var extent: Double {
            switch self {
            case .none:
                return 1
            case .kilo:
                return 1000
            case .mega:
                return 1_000_000
            case .giga:
                return 1_000_000_000
            case .tera:
                return 1_000_000_000_000
            case .peta:
                return 1_000_000_000_000_000
            case .exa:
                return 1_000_000_000_000_000_000
            }
        }
        
        var abbreviation: String {
            switch self {
            case .none:
                return ""
            case .kilo:
                return "k"
            case .mega:
                return "M"
            case .giga:
                return "G"
            case .tera:
                return "T"
            case .peta:
                return "P"
            case .exa:
                return "E"
            }
        }
    }
}


