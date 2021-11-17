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
    
    public let blankIfZero: Bool
    public let roundSmallToWhole: Bool
    
    let threshold: Double
    let netKiloExtent: Double
    let netMegaExtent: Double
    let netGigaExtent: Double
    let netTeraExtent: Double
    let netPetaExtent: Double
    let netExaExtent: Double
    
    public init(blankIfZero: Bool = false,
                roundSmallToWhole: Bool = false) {
        self.blankIfZero = blankIfZero
        self.roundSmallToWhole = roundSmallToWhole
        self.threshold = roundSmallToWhole ? 0.5 : 0.05
        self.netKiloExtent = Scale.kilo.extent - threshold
        self.netMegaExtent = Scale.mega.extent - threshold * Scale.kilo.extent
        self.netGigaExtent = Scale.giga.extent - threshold * Scale.mega.extent
        self.netTeraExtent = Scale.tera.extent - threshold * Scale.giga.extent
        self.netPetaExtent = Scale.peta.extent - threshold * Scale.tera.extent
        self.netExaExtent = Scale.exa.extent - threshold * Scale.peta.extent
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func string(from value: NSNumber) -> String? {
        let absValue = abs(Double(truncating: value))
        
        if blankIfZero, absValue <= threshold { return "" }
        
        var netValue = Double(truncating: value)
        var scaleSymbol: Scale = .none
        
        switch absValue {
        case 0.0 ... threshold:
            // if inside threshold, drop the fraction, to avoid awkward "-$0"
            netValue = 0.0
        case threshold ..< netKiloExtent:
            _ = 0 // verbatim netValue
        case netKiloExtent ..< netMegaExtent:
            netValue /= Scale.kilo.extent
            scaleSymbol = .kilo
        case netMegaExtent ..< netGigaExtent:
            netValue /= Scale.mega.extent
            scaleSymbol = .mega
        case netGigaExtent ..< netTeraExtent:
            netValue /= Scale.giga.extent
            scaleSymbol = .giga
        case netTeraExtent ..< netPetaExtent:
            netValue /= Scale.tera.extent
            scaleSymbol = .tera
        case netPetaExtent ..< netExaExtent:
            netValue /= Scale.peta.extent
            scaleSymbol = .peta
        default:
            netValue /= Scale.exa.extent
            scaleSymbol = .exa
        }
        
        let smallValueThreshold = 100 - threshold
        let isSmallAbsValue = absValue < smallValueThreshold
        let isLargeNetValue = smallValueThreshold <= abs(netValue)
        let roundToWhole = isSmallAbsValue && roundSmallToWhole
        let fractionDigitCount = roundToWhole || isLargeNetValue ? 0 : 1
        
        self.maximumFractionDigits = fractionDigitCount
        self.minimumFractionDigits = fractionDigitCount
        self.usesGroupingSeparator = false
        
        guard let raw = super.string(from: netValue as NSNumber) else { return nil }
        
        guard let lastDigitIndex = raw.lastIndex(where: { $0.isNumber }) else { return nil }
        
        let afterLastDigitIndex = raw.index(after: lastDigitIndex)
        
        let prefix = raw.prefix(upTo: afterLastDigitIndex)
        let suffix = raw.suffix(from: afterLastDigitIndex)
        
        return "\(prefix)\(scaleSymbol.abbreviation)\(suffix)"
    }
}

