//
//  TimeCompactor.swift
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

public class TimeCompactor: NumberFormatter {
    
    public let blankIfZero: Bool
    public let style: Style
    public let roundSmallToWhole: Bool
    
    let threshold: TimeInterval
    let netMinuteExtent: TimeInterval
    let netHourExtent: TimeInterval
    let netDayExtent: TimeInterval
    let netYearExtent: TimeInterval
    let netCenturyExtent: TimeInterval
    let netMilleniumExtent: TimeInterval

    public init(blankIfZero: Bool = false,
                style: Style = .short,
                roundSmallToWhole: Bool = false) {
        self.blankIfZero = blankIfZero
        self.style = style
        self.roundSmallToWhole = roundSmallToWhole
        self.threshold = roundSmallToWhole ? 0.5 : 0.05
        self.netMinuteExtent = Scale.minute.extent - threshold
        self.netHourExtent = Scale.hour.extent - threshold * Scale.minute.extent
        self.netDayExtent = Scale.day.extent - threshold * Scale.hour.extent
        self.netYearExtent = Scale.year.extent - threshold * Scale.day.extent
        self.netCenturyExtent = Scale.century.extent - threshold * Scale.year.extent
        self.netMilleniumExtent = Scale.millenium.extent - threshold * Scale.century.extent
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func string(from value: NSNumber) -> String? {
        let absValue = abs(TimeInterval(truncating: value))
        
        if blankIfZero, absValue <= threshold { return "" }
        
        var scaleSymbol: Scale = .second
        var netValue = TimeInterval(truncating: value)
        
        switch absValue {
        case 0.0 ... threshold:
            // if inside threshold, drop the fraction, to avoid awkward "-0s"
            netValue = 0.0
        case threshold ..< netMinuteExtent:
            _ = 0 // verbatim netValue
        case netMinuteExtent ..< netHourExtent:
            netValue /= Scale.minute.extent
            scaleSymbol = .minute
        case netHourExtent ..< netDayExtent:
            netValue /= Scale.hour.extent
            scaleSymbol = .hour
        case netDayExtent ..< netYearExtent:
            netValue /= Scale.day.extent
            scaleSymbol = .day
        case netYearExtent ..< netCenturyExtent:
            netValue /= Scale.year.extent
            scaleSymbol = .year
        case netCenturyExtent ..< netMilleniumExtent:
            netValue /= Scale.century.extent
            scaleSymbol = .century
        default:
            netValue /= Scale.millenium.extent
            scaleSymbol = .millenium
        }
        
        let smallValueThreshold = 100 - threshold
        let isLargeNetValue = smallValueThreshold <= abs(netValue)
        let roundToWhole = !isLargeNetValue && roundSmallToWhole
        let fractionDigitCount = roundToWhole || isLargeNetValue ? 0 : 1
        
        self.numberStyle = .decimal
        self.minimumFractionDigits = fractionDigitCount
        self.maximumFractionDigits = fractionDigitCount
        self.usesGroupingSeparator = false
        
        guard let raw = super.string(from: netValue as NSNumber) else { return nil }

        guard let lastDigitIndex = raw.lastIndex(where: { $0.isNumber }) else { return nil }

        let afterLastDigitIndex = raw.index(after: lastDigitIndex)

        let prefix = raw.prefix(upTo: afterLastDigitIndex)

        switch style {
        case .short:
            return "\(prefix)\(scaleSymbol.abbreviation)"
        case .full:
            let isPlural = prefix != "1"
            let unit = isPlural ? scaleSymbol.plural : scaleSymbol.singular
            return "\(prefix) \(unit)"
        }
    }
}
