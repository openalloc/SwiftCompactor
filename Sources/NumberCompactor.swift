//
//  NumberCompactor.swift
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

import Foundation

public class NumberCompactor: NumberFormatter {
    
    public var blankIfZero: Bool
    public var roundSmallToWhole: Bool
    
    public init(blankIfZero: Bool = false,
                roundSmallToWhole: Bool = false) {
        self.blankIfZero = blankIfZero
        self.roundSmallToWhole = roundSmallToWhole
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func string(from value: NSNumber) -> String? {
        let rawValue: Double = Double(truncating: value)
        let absValue = abs(rawValue)
        let threshold = NumberCompactor.getThreshold(roundSmallToWhole)
        
        if blankIfZero, absValue <= threshold { return "" }
                
        let (scaledValue, scaleSymbol) = NumberCompactor.getScaledValue(rawValue, roundSmallToWhole)
        
        let showWholeValue: Bool = {
            let smallValueThreshold = 100 - threshold
            if smallValueThreshold <= abs(scaledValue) { return true }
            let isSmallAbsValue = absValue < smallValueThreshold
            return isSmallAbsValue && roundSmallToWhole
        }()
        
        let fractionDigitCount = showWholeValue ? 0 : 1
        self.maximumFractionDigits = fractionDigitCount
        self.minimumFractionDigits = fractionDigitCount
        
        guard let raw = super.string(from: scaledValue as NSNumber),
              let lastDigitIndex = raw.lastIndex(where: { $0.isNumber })
        else { return nil }
        
        let afterLastDigitIndex = raw.index(after: lastDigitIndex)
        let prefix = raw.prefix(upTo: afterLastDigitIndex)
        let suffix = raw.suffix(from: afterLastDigitIndex)
        
        return "\(prefix)\(scaleSymbol.abbreviation)\(suffix)"
    }
}

extension NumberCompactor {
    
    private typealias LOOKUP = (range: Range<Double>, divisor: Double, scale: Scale)
    
    // thresholds
    private static let halfDollar: Double = 0.5
    private static let nickel: Double = 0.05

    // cached lookup tables
    private static let halfDollarLookup: [LOOKUP] = NumberCompactor.generateLookup(threshold: halfDollar)
    private static let nickelLookup: [LOOKUP] = NumberCompactor.generateLookup(threshold: nickel)

    static func getThreshold(_ roundSmallToWhole: Bool) -> Double {
        roundSmallToWhole ? NumberCompactor.halfDollar : NumberCompactor.nickel
    }
    
    static func getScaledValue(_ rawValue: Double, _ roundSmallToWhole: Bool) -> (Double, Scale) {
        let threshold = getThreshold(roundSmallToWhole)
        let absValue = abs(rawValue)
        if !(0.0...threshold).contains(absValue) {
            if let (divisor, scale) = NumberCompactor.lookup(roundSmallToWhole, absValue) {
                let netValue = rawValue / divisor
                return (netValue, scale)
            }
        }
        return (0.0, .none)
    }
    
    private static func lookup(_ roundSmallToWhole: Bool, _ absValue: Double) -> (divisor: Double, scale: Scale)? {
        let records = roundSmallToWhole ? NumberCompactor.halfDollarLookup : NumberCompactor.nickelLookup
        guard let record = records.first(where: { $0.range.contains(absValue) }) else { return nil }
        return (record.divisor, record.scale)
    }
    
    private static func generateLookup(threshold: Double) -> [LOOKUP] {
        let netKiloExtent: Double = Scale.kilo.extent - threshold
        let netMegaExtent: Double = Scale.mega.extent - threshold * Scale.kilo.extent
        let netGigaExtent: Double = Scale.giga.extent - threshold * Scale.mega.extent
        let netTeraExtent: Double = Scale.tera.extent - threshold * Scale.giga.extent
        let netPetaExtent: Double = Scale.peta.extent - threshold * Scale.tera.extent
        let netExaExtent : Double = Scale.exa.extent  - threshold * Scale.peta.extent
        
        return [
            (threshold ..< netKiloExtent, 1.0, .none),
            (netKiloExtent ..< netMegaExtent, Scale.kilo.extent, .kilo),
            (netMegaExtent ..< netGigaExtent, Scale.mega.extent, .mega),
            (netGigaExtent ..< netTeraExtent, Scale.giga.extent, .giga),
            (netTeraExtent ..< netPetaExtent, Scale.tera.extent, .tera),
            (netPetaExtent ..< netExaExtent, Scale.peta.extent, .peta),
            (netExaExtent  ..< Double.greatestFiniteMagnitude, Scale.exa.extent, .exa),
        ]
    }
}

