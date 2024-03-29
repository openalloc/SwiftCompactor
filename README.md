# SwiftCompactor

Formatters for the concise display of Numbers, Currency, and Time Intervals

Why _SwiftCompactor_? First, use where precision isn’t critical, but space is at a premium. Second, compact values like `$8.6M` are more easily grasped over values like `$8,603,842.35`, lowering the cognitive load for the user.

Available as an open source Swift library to be incorporated in other apps.

_Compactor_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

<img src="https://github.com/openalloc/SwiftCompactor/blob/main/Images/examples.png" width="800" height="305"/>

## NumberCompactor

```swift
let c = NumberCompactor()
print(c.string(from: 1_234_567))

=> "1.2M"
```

By default, values will show up to one fractional decimal point of the value, rounded if necessary.

### Options

* `ifZero` (default: `(String?)nil`) - if nil and value is zero, a zero value will be shown. If !nil and value is zero, the specified string value will be shown
* `roundSmallToWhole` (default: `false`) - if true, fractional parts excluded from values within `-100...100`

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

By default, values within `-100...100` will have no fractional part, and are rounded where necessary. Outside that one fractional decimal point of the value is shown, rounded if necessary.

### Options

* `ifZero` (default: `(String?)nil`) - if nil and value is zero, a zero value will be shown. If !nil and value is zero, the specified string value will be shown
* `roundSmallToWhole` (default: `true`) - if true, fractional parts excluded from values within `-100...100`

Note that `roundSmallToWhole` is true by default, because `$1.1` looks awkward when we’re accustomed to fractions in pennies.

### Suffixes

The same as used with `NumberCompactor()`.

## TimeCompactor

With `TimeCompactor()` you provide it a `TimeInterval` value to be transformed into a string value.

```swift
let c = TimeCompactor()
print(c.string(from: 1_234_567))

=> "14.3d"

let f = TimeCompactor(style: .full)
print(f.string(from: 1_234_567))

=> "14.3 days"
```

By default, values will show up to one fractional decimal point of the value, rounded if necessary.

### Options

* `ifZero` (default: `(String?)nil`) - if nil and value is zero, a zero value will be shown. If !nil and value is zero, the specified string value will be shown
* `style` (default: `.short`) - the style of suffix used
* `roundSmallToWhole` (default: `false`) - if true, fractional parts excluded from values within `-100...100`

### Suffixes

The suffix will depend on the style, of which there is currently `.short` (default), `.medium`, and `.full`.

| short  | medium | full                | value      |
| ------ | ------ | ------------------- | ---------- |
|   s    |  sec   | second              | 1          |
|   m    |  min   | minute              | 60         |
|   h    |  hr    | hour                | 3,600      |
|   d    |  day   | day                 | 86,400     |
|   y    |  yr    | year                | d × 365.25 |
|   c    |  cent  | century             | y × 100    |
|   ky   |  ky    | millennium          | y × 1000   |

Note that `.medium` and `.full` include plural forms.

## See Also

This library is a member of the _OpenAlloc Project_.

* [_OpenAlloc_](https://openalloc.github.io) - product website for all the _OpenAlloc_ apps and libraries
* [_OpenAlloc Project_](https://github.com/openalloc) - Github site for the development project, including full source code

## License

Copyright 2021, 2022 OpenAlloc LLC

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.

Contributions should ultimately have adequate test coverage. See tests for current entities to see what coverage is expected.
