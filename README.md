# SwiftCompactor

Formatters for the concise display of Numbers, Currency, and Time Intervals

Available as an open source Swift library to be incorporated in other apps.

_Compactor_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

## NumberCompactor

```swift
let c = NumberCompactor()
print(c.string(from: 1_234_567))

=> "1.2M"
```

By default, values will show up to one fractional decimal point of the value, rounded if necessary.

### Options

* `blankIfZero` (default: false) - if true, a value of zero will return ""
* `roundSmallToWhole` (default: false) - if true, fractional parts excluded from values within -100...100

### Suffixes

| suffix | description         | value  |
| ------ | ------------------- | ------ |
|   k    | kilo (thousand)     | 1000^1 |
|   M    | mega (million)      | 1000^2 |
|   G    | giga (billion)      | 1000^3 |
|   T    | tera (trillion)     | 1000^4 |
|   P    | peta (quadrillion)  | 1000^5 |
|   E    | exa (quintillion)   | 1000^6 |

For more detail see the [Binary Prefix](https://en.wikipedia.org/wiki/Binary_prefix) page at Wikipedia.

## CurrencyCompactor

```swift
let c = CurrencyCompactor()
print(c.string(from: 1_234_567))

=> "$1.2M"
```

By default, values within -100...100 will have no fractional part, and are rounded where necessary. Outside that one fractional decimal point of the value is shown, rounded if necessary.

### Options

* `blankIfZero` (default: false) - if true, a value of zero will return ""
* `roundSmallToWhole` (default: true) - if true, fractional parts excluded from values within -100...100

Note that `roundSmallToWhole` is true by default, because `$1.1` looks awkward when we're accustomed to fractions in pennies.

### Suffixes

The same as used with `NumberCompactor()`.

## TimeCompactor

```swift
let c = TimeCompactor(style: .full)
print(c.string(from: 1_234_567))

=> "14.3 days"
```

By default, values will show up to one fractional decimal point of the value, rounded if necessary.

### Options

* `blankIfZero` (default: false) - if true, a value of zero will return ""
* `style` (default: `.short`) - the style of suffix used
* `roundSmallToWhole` (default: false) - if true, fractional parts excluded from values within -100...100

### Suffixes

The suffix will depend on the style, of which there is currently `.short` (default) and `.full`.

| short  | full                | value      |
| ------ | ------------------- | ---------- |
|   s    | second              | 1          |
|   m    | minute              | 60         |
|   h    | hour                | 3,600      |
|   d    | day                 | 86,400     |
|   y    | year                | d × 365.25 |
|   c    | century             | y × 100    |
|   ky   | millennium          | y × 1000   |

## See Also

Swift open-source libraries (by the same author):

* [AllocData](https://github.com/openalloc/AllocData) - standardized data formats for investing-focused apps and tools
* [FINporter](https://github.com/openalloc/FINporter) - library and command-line tool to transform various specialized finance-related formats to the standardized schema of AllocData

And commercial apps using this library (by the same author):

* [FlowAllocator](https://flowallocator.app/FlowAllocator/index.html) - portfolio rebalancing tool for macOS
* [FlowWorth](https://flowallocator.app/FlowWorth/index.html) - a new portfolio performance and valuation tracking tool for macOS

## License

Copyright 2021 FlowAllocator LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.

Contributions should ultimately have adequate test coverage. See tests for current entities to see what coverage is expected.
