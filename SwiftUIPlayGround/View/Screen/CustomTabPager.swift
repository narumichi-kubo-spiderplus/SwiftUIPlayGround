//
//  TabPager.swift
//  SwiftUIPlayGround
//
//  Created by Narumichi Kubo on 2022/03/13.
//

import SwiftUI
import Parchment

struct CustomTabPager: View {
    let items = [
        PagingIndexItem(index: 0, title: "おはよう"),
        PagingIndexItem(index: 1, title: "こんにちわ"),
        PagingIndexItem(index: 2, title: "こんばんわ"),
    ]
    
    var body: some View {
        TabPager(items: items) { item in
            Text(item.title)
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

struct CustomTabPager_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabPager()
    }
}
