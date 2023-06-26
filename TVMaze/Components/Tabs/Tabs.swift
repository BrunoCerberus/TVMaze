//
//  Tabs.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation
import SwiftUI

public enum TabType {
    case centerable
    case scrollable
    case centerScrollable
}

public struct Tabs: View {
    let titles: [String]
    private let tabType: TabType
    @Binding var currentPage: Int
    @Binding var currentPosition: CGFloat
    private let usesPosition: Bool
    private let widthScaleMode: WidthScaleMode
    private var tabTapAction: (_ index: Int) -> Void

    @State private var availableSize: CGSize = .zero
    
    public init(titles: [String],
                currentPage: Binding<Int>,
                currentPosition: Binding<CGFloat> = Binding.constant(0),
                usesPosition: Bool = false,
                tabType: TabType = .scrollable,
                widthScaleMode: WidthScaleMode? = nil,
                tabTapAction: @escaping (_ index: Int) -> Void = { _ in }) {
        self.titles = titles
        self.tabType = tabType
        _currentPage = currentPage
        _currentPosition = currentPosition
        self.usesPosition = usesPosition
        self.tabTapAction = tabTapAction
        if let widthScaleMode = widthScaleMode {
            self.widthScaleMode = widthScaleMode
        } else {
            self.widthScaleMode = tabType == .centerable ? .flexible : .none
        }
    }
  
    public var body: some View {
        switch tabType {
        case .centerable:
            tabControl
                .frame(maxWidth: .infinity)
        case .scrollable:
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    tabControl
                }
                .onChange(of: currentPage, perform: { newValue in
                    withAnimation {
                        scrollView.scrollTo(currentPage)
                    }
                })
            }
        case .centerScrollable:
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    tabControl
                        .frame(minWidth: availableSize.width)
                }
                .onChange(of: currentPage, perform: { newValue in
                    withAnimation {
                        scrollView.scrollTo(currentPage)
                    }
                })
            }
            .sizeReader {
                availableSize = $0
            }
        }
    }

    private var tabControl: some View {
        TabControl(
            titles,
            widthScaleMode: widthScaleMode,
            selectedIndex: Binding($currentPage),
            currentPosition: usesPosition ? Binding($currentPosition) : .constant(nil),
            content: { item, isSelected, index in
                Tab(label: item, isActive: isSelected)
                    .id(index)
            },
            selection: {
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 2)
                }
                .padding(.vertical, Layout.padding(0.25))
            },
            onTapAction: tabTapAction)
    }
}
