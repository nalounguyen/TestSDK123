# CredifyIOS
This is included two project: `CredifyCore SDK`  and `CredifyKit SDK`


## CredifyCore
- It is used for `CredifyKit SDK` and `Credify App` for handling business and communicating with Backend and 
- There are two layers: `Repositories` and `UserCases`
- This is internal framework


### Dependencies
- CredifyCryptoSwift
- KeychainAccess
- RxSwift (version 5.0)
- RxCocoa (version 5.0)

### Requirements
- iOS 12+
- Swift 5


### How to build framework
- open terminal and go to  folder CredifyIOS/CredifyCore in project
- pod install
- open `CredifyCore.xcworkspace`
- selecte Target `TheCredifyCore` and build.
- copy `CredifyCore.framework`(CredifyIOS/CredifyCore/CredifyCore.framework) and paste to `CredifyIOS/CredifyKit`

### 


## CredifyKit
- It is used for third-party which integrate with Credify ecosystem

### Dependencies
- CredifyCryptoSwift
- KeychainAccess
- RxSwift (version 5.0)
- RxCocoa (version 5.0)
- lottie-ios
- Kingfisher


### How to build framework
- open terminal and go to  folder CredifyIOS/CredifyKit in project
- pod install
- build `CredifyCore` to `CredifyCore.framework`
- copy `CredifyCore.framework` to CredifyIOS/Credifykit
- selecte Target `TheCredifyKit` and build.

### Requirements
- iOS 12+
- Swift 5

### How to use

