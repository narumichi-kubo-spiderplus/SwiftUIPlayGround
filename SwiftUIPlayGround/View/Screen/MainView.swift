//
//  ContentView.swift
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("TabPager", destination: CustomTabPager())
            }
            .navigationTitle("SwiftUIPlayGround")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
