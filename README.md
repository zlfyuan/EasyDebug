![](./easyDebuglog.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Swift 5.0
- iOS 12.0

## Installation

### Cocoapods

EasyDebug is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasyDebug', :configurations => ['Debug']
or
pod 'EasyDebug', :git => 'https://github.com/zlfyuan/EasyDebug.git',  :configurations => ['Debug']
```

## Usage

At the project entry `AppDelegate`

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        EasyDebug.shared.start { option in
            option.debug = true
        }
        return true
}
```

## License

EasyDebug is available under the MIT license. See the LICENSE file for more info.
