//
//  CustomTabPager.swift
//

import SwiftUI
import Parchment

struct CustomTabPager: View {
    @State var selectedIndex: Int = 0
    let items = [
        PagingIndexItem(index: 0, title: "Page 1"),
        PagingIndexItem(index: 1, title: "Page 2"),
        PagingIndexItem(index: 2, title: "Page 3"),
    ]
    
    var body: some View {
        TabPager(selectedIndex: $selectedIndex, items: items) { item in
            Text(item.title)
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

struct CustomTabPager_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabPager(selectedIndex: .min)
    }
}
