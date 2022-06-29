# SwiftUIPlayGround

## [Perchment](https://github.com/rechsteiner/Parchment)
https://user-images.githubusercontent.com/65114797/176327827-657a349e-6d38-4085-89c7-d3e5ac50ab8e.mov


```swift:usage
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
```
