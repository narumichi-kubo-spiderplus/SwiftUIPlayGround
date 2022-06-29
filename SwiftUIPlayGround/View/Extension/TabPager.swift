//
//  TabPager.swift
//
import Parchment
import SwiftUI

/// アプリ全体で利用できるカスタムTabPager
/// OSSのParchmentを利用している
@available(iOS 13.0, *)
struct TabPager<Item: PagingItem, Page: View>: View {
    // 選択中のTabIndex
    @Binding var selectedIndex: Int
    // [PagingItem(index, title)]のリスト
    var items = [Item]()
    // 返り値でindex, titleが入ったオブジェクトが渡される
    let content: (Item) -> Page
    // ページングのオプション
    let options: CustomPagingOptions = CustomPagingOptions()
    // スクロール時に発火
    var onWillScroll: ((PagingItem) -> Void)?
    // スクロール後に発火
    var onDidScroll: ((PagingItem) -> Void)?
    // 選択時に発火
    var onDidSelect: ((PagingItem) -> Void)?
    
    var body: some View {
        PagingController(
            items: items,
            options: options,
            content: content,
            onWillScroll: onWillScroll,
            onDidScroll: onDidScroll,
            onDidSelect: onDidSelect,
            selectedIndex: $selectedIndex
        )
    }
    
    /// ページングのスタイルを定義する構造体
    struct CustomPagingOptions {
        // ページングのスタイル
        let options: PagingOptions = PagingOptions()
        // タブ下のBorderを非表示にするかどうか
        let isHiddenTabBorder: Bool = false
    }

    
    // スクロール後に発火
    private func didScroll(_ action: @escaping (PagingItem) -> Void) -> Self {
        var view = self
        view.onDidScroll = action
        return view
    }

    // スクロール時に発火
    private func willScroll(_ action: @escaping (PagingItem) -> Void) -> Self {
        var view = self
        view.onWillScroll = action
        return view
    }

    // 選択時に発火
    private func didSelect(_ action: @escaping (PagingItem) -> Void) -> Self {
        var view = self
        view.onDidSelect = action
        return view
    }

    // カスタム用にParchmentから継承したクラス
    final class CustomPagingViewController: PagingViewController {
        var items: [Item]?
    }

    // TabPagerを生成、レイアウトのカスタム、スクロール時に関数を発火させる
    struct PagingController: UIViewControllerRepresentable {
        let items: [Item]
        let options: CustomPagingOptions
        let content: (Item) -> Page
        var onWillScroll: ((PagingItem) -> Void)?
        var onDidScroll: ((PagingItem) -> Void)?
        var onDidSelect: ((PagingItem) -> Void)?

        @Binding var selectedIndex: Int

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        // UIViewControllerを生成
        func makeUIViewController(
            context: UIViewControllerRepresentableContext<PagingController>
        ) -> CustomPagingViewController {
            let pagingViewController = CustomPagingViewController(options: options.options)

            // Borderを表示するかどうか
            if options.isHiddenTabBorder {
                pagingViewController.borderOptions = .hidden
            }
            // tabの数が1つだった場合、Indicatorを非表示にする
            if items.count == 1 {
                pagingViewController.indicatorOptions = .hidden
            } else {
                // IndigatorのStyle
                pagingViewController.indicatorColor = UIColor(Color.green)
                pagingViewController.indicatorOptions = .visible(
                    height: 1.5,
                    zIndex: Int.max,
                    spacing: UIEdgeInsets.zero,
                    insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
                )
            }
            // 選択されていないTabのFont
            pagingViewController.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
            // 選択されていないTabのTextColor
            pagingViewController.textColor = UIColor.black
            // 選択中TabのFont
            pagingViewController.selectedFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
            // 選択中TabのTextColor
            pagingViewController.selectedTextColor = UIColor(Color.orange)
            // Tab全体の横スクロール
            pagingViewController.menuInteraction = .scrolling
            // TabPagerで利用するDatasourceを指定
            pagingViewController.dataSource = context.coordinator
            // TabPagerで利用するDelegateを指定
            pagingViewController.delegate = context.coordinator
            return pagingViewController
        }

        // UIViewControllerのUpdate時
        func updateUIViewController(
            _ pagingViewController: CustomPagingViewController,
            context: UIViewControllerRepresentableContext<PagingController>
        ) {
            context.coordinator.parent = self

            if pagingViewController.dataSource == nil {
                pagingViewController.dataSource = context.coordinator
            }

            if let previousItems = pagingViewController.items,
               !previousItems.elementsEqual(items, by: { $0.isEqual(to: $1) }) {
                pagingViewController.reloadData()
            }

            pagingViewController.items = items

            guard selectedIndex != Int.max else {
                return
            }

            pagingViewController.select(index: selectedIndex, animated: true)
        }
    }

    // TabPagerのDatasource,Delegateを管理するクラス
    final class Coordinator: PagingViewControllerDataSource, PagingViewControllerDelegate {
        var parent: PagingController

        init(_ pagingController: PagingController) {
            self.parent = pagingController
        }

        func numberOfViewControllers(in _: PagingViewController) -> Int {
            parent.items.count
        }

        func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
            let view = parent.content(parent.items[index])
            let hostingViewController = UIHostingController(rootView: view)
            // let backgroundColor = parent.options.pagingContentBackgroundColor
            // hostingViewController.view.backgroundColor = backgroundColor
            return hostingViewController
        }

        func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
            parent.items[index]
        }

        // スクロール時にParchmentから呼び出される関数
        func pagingViewController(
            _: PagingViewController,
            willScrollToItem pagingItem: PagingItem,
            startingViewController _: UIViewController,
            destinationViewController _: UIViewController
        ) {
            parent.onWillScroll?(pagingItem)
        }

        // スクロール後にParchmentから呼び出される関数
        func pagingViewController(
            _ controller: PagingViewController,
            didScrollToItem pagingItem: PagingItem,
            startingViewController _: UIViewController?,
            destinationViewController _: UIViewController,
            transitionSuccessful _: Bool
        ) {
            if let item = pagingItem as? Item,
               let index = parent.items.firstIndex(where: { $0.isEqual(to: item) }) {
                DispatchQueue.main.async {
                    self.parent.selectedIndex = index
                }
            }
            parent.onDidScroll?(pagingItem)
        }

        // スクロール後にParchmentから呼び出される関数
        func pagingViewController(_: PagingViewController, didSelectItem pagingItem: PagingItem) {
            parent.onDidSelect?(pagingItem)
        }
    }
}
