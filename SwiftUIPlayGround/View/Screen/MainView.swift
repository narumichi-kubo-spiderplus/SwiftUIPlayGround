//
//  ContentView.swift
//  SwiftUIPlayGround
//
//  Created by Narumichi Kubo on 2022/03/12.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("TabPager", destination: TabPager())
                
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
