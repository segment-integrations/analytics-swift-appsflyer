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

@main
struct BasicExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class DeepLinkManager: NSObject, DeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        print("Deep Link: \(result)")
    }
}

extension Analytics {
    static var main: Analytics {
        let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
        
        let deepLinkHandler = DeepLinkManager()
        let appsFlyer = AppsFlyerDestination(segDLDelegate: deepLinkHandler)
        analytics.add(plugin: appsFlyer)
        return analytics
    }
}
