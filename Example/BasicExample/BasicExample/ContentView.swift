//
//  ContentView.swift
//  BasicExample
//
//  Created by Brandon Sneed on 2/23/22.
//

import SwiftUI
import Segment

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    BasicExampleApp.analytics?.track(name: "Track")
                }, label: {
                    Text("Track")
                }).padding(6)
                Button(action: {
                    BasicExampleApp.analytics?.screen(title: "Screen appeared")
                }, label: {
                    Text("Screen")
                }).padding(6)
            }.padding(8)
            HStack {
                Button(action: {
                    BasicExampleApp.analytics?.group(groupId: "12345-Group")
                    BasicExampleApp.analytics?.log(message: "Started group")
                }, label: {
                    Text("Group")
                }).padding(6)
                Button(action: {
                    BasicExampleApp.analytics?.identify(userId: "X-1234567890")
                }, label: {
                    Text("Identify")
                }).padding(6)
            }.padding(8)
        }.onAppear {
            BasicExampleApp.analytics?.track(name: "onAppear")
            print("Executed Analytics onAppear()")
        }.onDisappear {
            BasicExampleApp.analytics?.track(name: "onDisappear")
            print("Executed Analytics onDisappear()")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
