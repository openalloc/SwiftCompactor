//
//  TimeCompactor.swift
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

public class TimeCompactor: NumberFormatter {
    
    public var ifZero: String?
    public var style: Style
    public var roundSmallToWhole: Bool
    
    @available(*, deprecated, message: "use init(ifZero: String?, style: Style, roundSmallToWhole: Bool) instead")
    public convenience init(blankIfZero: Bool = false,
                            style: Style = .short,
                            roundSmallToWhole: Bool = false) {
        self.init(ifZero: blankIfZero ? "" : nil,
                  style: style,
                  roundSmallToWhole: roundSmallToWhole)
    }
    
    public init(ifZero: String? = nil,
                style: Style = .short,
                roundSmallToWhole: Bool = false) {
        
        self.ifZero = ifZero
        self.style = style
        self.roundSmallToWhole = roundSmallToWhole
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func string(from value: NSNumber) -> String? {
        let rawValue: Double = Double(truncating: value)
        let absValue = abs(rawValue)
        let threshold = TimeCompactor.getThreshold(roundSmallToWhole)
        
        if ifZero != nil, absValue <= threshold { return ifZero! }
        
        let (scaledValue, scaleSymbol) = TimeCompactor.getScaledValue(rawValue, roundSmallToWhole)
                
        let showWholeValue: Bool = {
            let smallValueThreshold = 100 - threshold
            let isLargeNetValue = smallValueThreshold <= abs(scaledValue)
            let roundToWhole = !isLargeNetValue && roundSmallToWhole
            return roundToWhole || isLargeNetValue
        }()
        
        let fractionDigitCount = showWholeValue ? 0 : 1
        self.minimumFractionDigits = fractionDigitCount
        self.maximumFractionDigits = fractionDigitCount
        
        guard let raw = super.string(from: scaledValue as NSNumber),
              let lastDigitIndex = raw.lastIndex(where: { $0.isNumber })
        else { return nil }

        let afterLastDigitIndex = raw.index(after: lastDigitIndex)
        let prefix = raw.prefix(upTo: afterLastDigitIndex)

        switch style {
        case .short:
            return "\(prefix)\(scaleSymbol.shortAbbreviation)"
        case .medium, .full:
            let unit: String = {
                if prefix != "1" {
                    return style == .medium ? scaleSymbol.mediumPlural : scaleSymbol.fullPlural
                } else {
                    return style == .medium ? scaleSymbol.mediumSingular : scaleSymbol.fullSingular
                }
            }()
            return "\(prefix) \(unit)"
        }
    }
}

extension TimeCompactor {
    private typealias LOOKUP = (range: Range<Double>, divisor: Double, scale: Scale)
    
    // thresholds
    private static let halfDollar: Double = 0.5
    private static let nickel: Double = 0.05

    // cached lookup tables
    private static let halfDollarLookup: [LOOKUP] = TimeCompactor.generateLookup(threshold: halfDollar)
    private static let nickelLookup: [LOOKUP] = TimeCompactor.generateLookup(threshold: nickel)

    static func getThreshold(_ roundSmallToWhole: Bool) -> Double {
        roundSmallToWhole ? TimeCompactor.halfDollar : TimeCompactor.nickel
    }
    
    static func getScaledValue(_ rawValue: Double, _ roundSmallToWhole: Bool) -> (Double, Scale) {
        let threshold = getThreshold(roundSmallToWhole)
        let absValue = abs(rawValue)
        if !(0.0...threshold).contains(absValue) {
            if let (divisor, scale) = TimeCompactor.lookup(roundSmallToWhole, absValue) {
                let netValue = rawValue / divisor
                return (netValue, scale)
            }
        }
        return (0.0, .second)
    }
    
    private static func lookup(_ roundSmallToWhole: Bool, _ absValue: Double) -> (divisor: Double, scale: Scale)? {
        let records = roundSmallToWhole ? TimeCompactor.halfDollarLookup : TimeCompactor.nickelLookup
        guard let record = records.first(where: { $0.range.contains(absValue) }) else { return nil }
        return (record.divisor, record.scale)
    }
    
    private static func generateLookup(threshold: Double) -> [LOOKUP] {
        let netMinuteExtent: Double = Scale.minute.extent - threshold
        let netHourExtent: Double = Scale.hour.extent - threshold * Scale.minute.extent
        let netDayExtent: Double = Scale.day.extent - threshold * Scale.hour.extent
        let netYearExtent: Double = Scale.year.extent - threshold * Scale.day.extent
        let netCenturyExtent: Double = Scale.century.extent - threshold * Scale.year.extent
        let netMilleniumExtent : Double = Scale.millenium.extent  - threshold * Scale.century.extent
        
        return [
            (threshold ..< netMinuteExtent, 1.0, .second),
            (netMinuteExtent ..< netHourExtent, Scale.minute.extent, .minute),
            (netHourExtent ..< netDayExtent, Scale.hour.extent, .hour),
            (netDayExtent ..< netYearExtent, Scale.day.extent, .day),
            (netYearExtent ..< netCenturyExtent, Scale.year.extent, .year),
            (netCenturyExtent ..< netMilleniumExtent, Scale.century.extent, .century),
            (netMilleniumExtent  ..< Double.greatestFiniteMagnitude, Scale.millenium.extent, .millenium),
        ]
    }
}
