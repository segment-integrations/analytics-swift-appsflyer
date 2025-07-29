//
//  BasicExampleApp.swift
//  BasicExample
//
//  Created by Brandon Sneed on 2/23/22.
//

import SwiftUI
import Segment
import SegmentAppsFlyer
import AppsFlyerLib
import AppTrackingTransparency

@main
struct BasicExampleApp: App {
    static var analytics: Analytics? = nil
    static var appsflyerDest: AppsFlyerDestination!
    static var afDelegate: AFDelgate!
    init() {
        // Initialize delegate first and store it
        BasicExampleApp.afDelegate = AFDelgate()       
        BasicExampleApp.analytics = Analytics(configuration: Configuration(writeKey: "<WRITE_KEY>")
                            .flushAt(3)
                            .trackApplicationLifecycleEvents(true)
                            )
        
        AppsFlyerLib.shared().isDebug = true
        //If waiting to ATT status please wait for it using the below line.
        //AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60) 

        // Use the stored delegate
        BasicExampleApp.appsflyerDest = AppsFlyerDestination(
            segDelegate: BasicExampleApp.afDelegate,
            segDLDelegate: BasicExampleApp.afDelegate,
        )
        BasicExampleApp.analytics?.add(plugin: NewAnalyticsAppsflyerIntegrationApp.appsflyerDest)
    }

    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // Tracking authorization granted
                break
            case .denied, .notDetermined, .restricted:
                // Handle the case when permission is denied or not yet determined
                break
            @unknown default:
                break
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AFDelgate: NSObject, AppsFlyerLibDelegate, DeepLinkDelegate{
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("moris testing onConversionDataSuccess")
    }
    
    func onConversionDataFail(_ error: any Error) {
        print("moris testing onConversionDataFail")
    }
    func didResolveDeepLink(_ result: DeepLinkResult) {
        print("Deep Link: \(result)")
    }
}
