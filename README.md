# Analytics-Swift AppsFlyer

Add AppsFlyer device mode support to your applications via this plugin for [Analytics-Swift](https://github.com/segmentio/analytics-swift)

⚠️ **Github Issues disabled in this repository** ⚠️

Please direct Segment issues, bug reports, and feature enhancements to `friends@segment.com` so they can be resolved as efficiently as possible. 
Please direct Appsflyer issues, bug reports, and feature enhancements to `support@appsflyer.com` so they can be resolved as efficiently as possible. 

## Adding the dependency

***Note:** the AppsFlyer library itself will be installed as an additional dependency.*

### via Xcode
In the Xcode `File` menu, click `Add Packages`.  You'll see a dialog where you can search for Swift packages.  In the search field, enter the URL to this repo.

https://github.com/segment-integrations/analytics-swift-appsflyer

You'll then have the option to pin to a version, or specific branch, as well as which project in your workspace to add it to.  Once you've made your selections, click the `Add Package` button.  

### via Package.swift

Open your Package.swift file and add the following do your the `dependencies` section:

```
.package(
            name: "Segment",
            url: "https://github.com/segment-integrations/analytics-swift-appsflyer.git",
            from: "1.1.3"
        ),
```


*Note the AppsFlyer library itself will be installed as an additional dependency.*


## Using the Plugin in your App

Open the file where you setup and configure the Analytics-Swift library.  Add this plugin to the list of imports.

```
import Segment
import SegmentAppsFlyer // <-- Add this line
```

Just under your Analytics-Swift library setup, call `analytics.add(plugin: ...)` to add an instance of the plugin to the Analytics timeline.

```
let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
analytics.add(plugin: AppsFlyerDestination())
```

Your events will now begin to flow to AppsFlyer in device mode.

## Appsflyer SDK documentation
Please go here to see the Appsflyer Native iOS documentation [here](https://dev.appsflyer.com/hc/docs/ios-sdk)

## <a id="manual"> Manual mode
We support a manual mode to seperate the initialization of the AppsFlyer SDK and the start of the SDK. In this case, the AppsFlyer SDK won't start automatically, giving the developer more freedom when to start the AppsFlyer SDK. Please note that in manual mode, the developper is required to implement the API ``startAppsflyerSDK()`` in order to start the SDK. 
<br>If you are using CMP to collect consent data this feature is needed. See explanation [here](#dma_support).
### Example:
#### swift  
```swift
struct NewAnalyticsAppsflyerIntegrationApp: App {
    static var analytics: Analytics? = nil
    static var appsflyerDest: AppsFlyerDestination!
    init() {
        self.requestTrackingAuthorization()
        NewAnalyticsAppsflyerIntegrationApp.analytics = Analytics(configuration: Configuration(writeKey: "<WRITE_KEY>")
                            .flushAt(3)
                            .trackApplicationLifecycleEvents(true)
                            )
        AppsFlyerLib.shared().isDebug = true
//        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        NewAnalyticsAppsflyerIntegrationApp.appsflyerDest = AppsFlyerDestination(segDelegate: sfdelegate, segDLDelegate: sfdelegate, manualMode: true)
        NewAnalyticsAppsflyerIntegrationApp.analytics?.add(plugin: NewAnalyticsAppsflyerIntegrationApp.appsflyerDest)
    }
...
``` 

To start the AppsFlyer SDK, use the `startAppsflyerSDK()` API, like the following :
#### swift  
```swift
// check cmp response or check manually for the User's response.
// if decided to start the Appsflyer SDK manually do it like here:
NewAnalyticsAppsflyerIntegrationApp.appsflyerDest.startAppsflyerSDK()
```

## <a id="getconversiondata"> Get Conversion Data
  
  In order for Conversion Data to be sent to Segment, make sure you have enabled "Track Attribution Data" and specified App ID in AppsFlyer destination settings:
  
![image](https://user-images.githubusercontent.com/50541317/69795158-51b86780-11d4-11ea-9ab3-be3e669e4e3b.png)
  
### <a id="gcd-swift"> Swift
  
  In order to get Conversion Data you need to:
  
  1. Create a class applies the AppsFlyerLibDelegate delgeate 
  2. Pass the initialized class to the AppsflyerDestination
  3. Implement methods of the protocol in the class, passed as a delegate. See sample code below where AppDelegate is used for that:
  
  ```swift
struct NewAnalyticsAppsflyerIntegrationApp: App {
    static var afDelegate: AFDelgate! // Add strong reference to delegate
    
    init() {
...
        NewAnalyticsAppsflyerIntegrationApp.afDelegate = AFDelgate()
        
        NewAnalyticsAppsflyerIntegrationApp.analytics = Analytics(configuration: Configuration(writeKey: "<WRITE_KEY>")
                            .flushAt(3)
                            .trackApplicationLifecycleEvents(true)
                            )
        
        AppsFlyerLib.shared().isDebug = true
        
        // Use the stored delegate
        NewAnalyticsAppsflyerIntegrationApp.appsflyerDest = AppsFlyerDestination(
            segDelegate: NewAnalyticsAppsflyerIntegrationApp.afDelegate,
            segDLDelegate: nil
        )
        NewAnalyticsAppsflyerIntegrationApp.analytics?.add(plugin: NewAnalyticsAppsflyerIntegrationApp.appsflyerDest)
    }
...
...
  class AFDelgate: NSObject, AppsFlyerLibDelegate{
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("moris testing onConversionDataSuccess")
    }
    
    func onConversionDataFail(_ error: any Error) {
        print("moris testing onConversionDataFail")
    }
}
  ```

## <a id="DDL"> Unified Deep linking
### <a id="ddl-swift"> Swift
In order to use Unified Deep linking you need to:
  
  1. Create a class applies the DeepLinkDelegate delgeate
  2. Pass the initialized class to the AppsflyerDestination
  ```swift
  let factoryWithDelegate: SEGAppsFlyerIntegrationFactory = SEGAppsFlyerIntegrationFactory.create(withLaunch: self, andDeepLinkDelegate: self)
  ```

  3. Implement methods of the protocol in the class, passed as a delegate. See sample code below where AppDelegate is used for that:
  
  ```swift
struct NewAnalyticsAppsflyerIntegrationApp: App {
    static var afDelegate: AFDelgate! // Add strong reference to delegate
    
    init() {
...
        NewAnalyticsAppsflyerIntegrationApp.afDelegate = AFDelgate()
        
        NewAnalyticsAppsflyerIntegrationApp.analytics = Analytics(configuration: Configuration(writeKey: "<WRITE_KEY>")
                            .flushAt(3)
                            .trackApplicationLifecycleEvents(true)
                            )
        
        AppsFlyerLib.shared().isDebug = true
        
        // Use the stored delegate
        NewAnalyticsAppsflyerIntegrationApp.appsflyerDest = AppsFlyerDestination(
            segDelegate: nil,
            segDLDelegate: NewAnalyticsAppsflyerIntegrationApp.afDelegate
        )
        NewAnalyticsAppsflyerIntegrationApp.analytics?.add(plugin: NewAnalyticsAppsflyerIntegrationApp.appsflyerDest)
    }
...
...
  class AFDelgate: NSObject, DeepLinkDelegate{
    func didResolveDeepLink(_ result: DeepLinkResult) {
        print("Deep Link: \(result)")
    }
}
  ```

## <a id="dma_support"> Send consent for DMA compliance
**important:** As of Appsflyer SDK 6.17.0 there are additions in the Appsflyer SDK API on how to use DMA, [see here](https://dev.appsflyer.com/hc/docs/ios-send-consent-for-dma-compliance).<br>
The SDK offers two alternative methods for gathering consent data:<br>
- **Through a Consent Management Platform (CMP)**: If the app uses a CMP that complies with the [Transparency and Consent Framework (TCF) v2.2 protocol](https://iabeurope.eu/tcf-supporting-resources/), the SDK can automatically retrieve the consent details.<br>
<br>OR<br><br>
- **Through a dedicated SDK API**: Developers can pass Google's required consent data directly to the SDK using a specific API designed for this purpose.
### Use CMP to collect consent data
A CMP compatible with TCF v2.2 collects DMA consent data and stores it in <code>NSUserDefaults</code>. To enable the SDK to access this data and include it with every event, follow these steps:<br>
<ol>
  <li> Call <code>AppsFlyerLib.shared().enableTCFDataCollection(true)</code> to instruct the SDK to collect the TCF data from the device.
  <li> Initialize <code>AppsFlyerDestination</code> using manualMode = true. This will allow us to delay the Conversion call in order to provide the SDK with the user consent.
  <li> In the <code>applicationDidBecomeActive</code> lifecycle method, use the CMP to decide if you need the consent dialog in the current session to acquire the consent data. If you need the consent dialog move to step 4; otherwise move to step 5.
  <li> Get confirmation from the CMP that the user has made their consent decision and the data is available in <code>NSUserDefaults</code>.
  <li> Call <code>startAppsflyerSDK()</code>.
</ol>


```swift

static var analytics: Analytics? = nil
static var appsflyerDest: AppsFlyerDestination!
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // For AppsFLyer debug logs uncomment the line below
    AppsFlyerLib.shared().isDebug = true
    AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
    AppsFlyerLib.shared().enableTCFDataCollection(true)
    NewAnalyticsAppsflyerIntegrationApp.analytics = Analytics(configuration: Configuration(writeKey: "<WRITE_KEY>")
                            .flushAt(3)
                            .trackApplicationLifecycleEvents(true)
                            )
    NewAnalyticsAppsflyerIntegrationApp.appsflyerDest = AppsFlyerDestination(segDelegate: sfdelegate, segDLDelegate: sfdelegate, manualMode: true)
    NewAnalyticsAppsflyerIntegrationApp.analytics?.add(plugin: NewAnalyticsAppsflyerIntegrationApp.appsflyerDest)
    return true
}

func applicationDidBecomeActive(_ application: UIApplication) {
    if(cmpManager!.hasConsent()){
        //CMP manager already has consent ready - you can start
        NewAnalyticsAppsflyerIntegrationApp.appsflyerDest.startAppsflyerSDK()
    }else{
        //CMP doesn't have consent data ready yet
        //Waiting for CMP completion and data ready and then start
        cmpManager?.withOnCmpButtonClickedCallback({ CmpButtonEvent in
           NewAnalyticsAppsflyerIntegrationApp.appsflyerDest.startAppsflyerSDK()
        })
    }
    
    if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization { (status) in
            switch status {
            case .denied:
                print("AuthorizationSatus is denied")
            case .notDetermined:
                print("AuthorizationSatus is notDetermined")
            case .restricted:
                print("AuthorizationSatus is restricted")
            case .authorized:
                print("AuthorizationSatus is authorized")
            @unknown default:
                fatalError("Invalid authorization status")
            }
        }
    }
}
```

### Manually collect consent data
If your app does not use a CMP compatible with TCF v2.2, use the SDK API detailed below to provide the consent data directly to the SDK.
<ol>
  <li> Initialize <code>AppsFlyerDestination</code> using manual mode. This will allow us to delay the Conversion call in order to provide the SDK with the user consent.
  <li> In the <code>applicationDidBecomeActive</code> lifecycle method determine whether the GDPR applies or not to the user.<br>
  - If GDPR applies to the user, perform the following: 
      <ol>
        <li> Given that GDPR is applicable to the user, determine whether the consent data is already stored for this session.
            <ol>
              <li> If there is no consent data stored, show the consent dialog to capture the user consent decision.
              <li> If there is consent data stored continue to the next step.
            </ol>
        <li> To transfer the consent data to the SDK create an AppsFlyerConsent object with the following parameters:<br>
          - <code>forGDPRUserWithHasConsentForDataUsage</code>- Indicates whether the user has consented to use their data for advertising purposes.
          - <code>hasConsentForAdsPersonalization</code>- Indicates whether the user has consented to use their data for personalized advertising.
        <li> Call <code>AppsFlyerLib.shared().setConsentData(AppsFlyerConsent(forGDPRUserWithHasConsentForDataUsage: Bool, hasConsentForAdsPersonalization: Bool))</code>. 
        <li> Call <code>NewAnalyticsAppsflyerIntegrationApp.appsflyerDest.startAppsflyerSDK()</code>.
      </ol><br>
    - If GDPR doesn’t apply to the user perform the following:
      <ol>
        <li> Call <code>AppsFlyerLib.shared().setConsentData(AppsFlyerConsent(nonGDPRUser: ()))</code>.
        <li> It is optional to initialize <code>AppsFlyerDestination</code> using manual mode not mandatory as before.
      </ol>
</ol>

  
## <a id="usage"> Usage

First of all, you must provide values for AppsFlyer Dev Key, Apple App ID (iTunes) and client secret in Segment's **dashboard** for AppsFlyer integration



## Support

Please use Github issues, Pull Requests, or feel free to reach out to our [support team](https://segment.com/help/).

## Integrating with Segment

Interested in integrating your service with us? Check out our [Partners page](https://segment.com/partners/) for more details.

## License
```
MIT License

Copyright (c) 2021 Segment

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
