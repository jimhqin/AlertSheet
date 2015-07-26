# AlertSheet

AlertSheet is a user interface alert inspired by UIActionSheet. 

<img src="Screenshots/AlertSheet.gif" width="210" height="320" />

## Features

- [x] Beautiful design
- [x] Customizable
- [x] Simple and lightweight
- [x] Future proofed for all screen sizes

## Requirements

- iOS 7.0+

## Installation

Drag and drop AlertSheet.swift, AlertSheetButton.swift and AlertSheetLabel.swift into your project.

## Usage

### Displaying an AlertSheet
```swift
let alertSheet = AlertSheet(
            title: "Network Error",
            message: "You appear to be offline. Check your connection and try again.",
            buttonTitle: "OK",
            image: nil
)
alertSheet.delegate = self
alertSheet.showInView(view)
```

### Handling AlertSheet State

```Swift
// MARK: - AlertSheetDelegate Protocol

func alertSheet(alertSheet: AlertSheet, clickedButtonAtIndex buttonIndex: Int) {
    switch buttonIndex {
    case 0: alertSheet.dismiss()
    default: alertSheet.dismiss()
    }
}
```
# License
AlertSheet is released under the MIT license. See [LICENSE](https://github.com/jimhqin/AlertSheet/blob/master/LICENSE) for details.
