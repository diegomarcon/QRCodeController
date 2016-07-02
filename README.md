# QRCodeController

Customisable QR Code Reader View Controller written in Swift

## Requirements
- iOS 8.0+

## Installation

QRCodeController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QRCodeController', '~> 0.1'
```

## Usage

Create QRCodeController
```Swift
let qrCodeController = QRCodeController()
```

Add callback for decoded strings
```Swift
qrCodeController.callback = { result in
    print(result)
}
```

Present it
```Swift
presentViewController(qrCodeController, animated: true, completion: nil)
```

## Customisable Properties 

- `var borderColor: UIColor`: Sets detection border color. Default is `UIColor.greenColor()`
- `var borderWidth: CGFloat`: Sets detection border width. Default is `2`
- `var vibrate: Bool`: Vibrate on code detection. Default is `true`
- `var closeAfterCapture: Bool`: Close controller after first capture. Default is `true`
- `var suppotedMetadataObjectTypes: [String]`: Supported metadata object types. Default is `[AVMetadataObjectTypeQRCode]`. More `AVMetadataObjectType's` can be found on `AVMetadataObject` reference.

## Author

Diego Marcon, dm.marcon@gmail.com

## License

QRCodeController is available under the MIT license. See the LICENSE file for more info.
