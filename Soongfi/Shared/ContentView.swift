//
//  ContentView.swift
//  Shared
//
//  Created by Taegyeong Lee on 2022/07/29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            NavigationView {
                List {
                        NavigationLink("앱 정보", destination: AppInfoView())
                }.navigationTitle("숭파이")
            }
    }
}

struct AppInfoView: View {
    var body: some View {
        Text("gkgkgk")
    }
}
                        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
