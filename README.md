# AlertSheet

AlertSheet is a user interface alert inspired by UIActionSheet.

## Features

- [x] Beautiful design
- [x] Customizable
- [x] Simple and lightweight
- [x] Future proofed for all screen sizes

![demo](Screenshots/AlertSheet.gif)

## Requirements

- iOS 7.0+

## Installation



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
