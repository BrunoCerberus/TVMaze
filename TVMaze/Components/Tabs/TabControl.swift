//
//  TabControl.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation
import SwiftUI

struct TabControl<Element, Content, Selection>: View where Content: View, Selection: View {
    @State private var frames: [CGRect]
    @Binding private var selectedIndex: Data.Index?
    @Binding private var currentPosition: CGFloat?
    private var onTap: (_ index: Int) -> Void

    private let data: [Element]
    private let widthScaleMode: WidthScaleMode
    private let selection: () -> Selection
    private let content: (Element, Bool, Int) -> Content
    
   init(_ data: [Element],
        widthScaleMode: WidthScaleMode = .none,
        selectedIndex: Binding<Array.Index?>,
        currentPosition: Binding<CGFloat?>,
        @ViewBuilder content: @escaping (Element, Bool, Int) -> Content,
        @ViewBuilder selection: @escaping () -> Selection,
        onTapAction: @escaping (_ index: Int) -> Void) {
       self.data = data
       self.widthScaleMode = widthScaleMode
       self.content = content
       self.selection = selection
       self.onTap = onTapAction
       self._selectedIndex = selectedIndex
       self._currentPosition = currentPosition
       self._frames = State(wrappedValue: Array(repeating: .zero, count: data.count))
    }
    
    public var body: some View {
        ZStack(alignment: Alignment(horizontal: .horizontalCenterAlignment, vertical: .center)) {
            if let currentIndex = currentIndex {
                selection()
                    .frame(width: tabWidth ?? frames[boundedIndex(currentIndex)].width,
                           height: frames[boundedIndex(currentIndex)].height)
                    .alignmentGuide(.horizontalCenterAlignment) { dimensions in
                        dimensions[HorizontalAlignment.center]
                    }
                    .offset(x: xOffset)
                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
            }
            HStack(spacing: Constants.horizontalTabSpacing) {
                ForEach(data.indices, id: \.self) { index in
                    Button {
                        onTap(index)
                        selectedIndex = index
                    } label: {
                        let isCurrentIndex = isCurrentIndex(index: index)
                        content(data[index], isCurrentIndex, index)
                            .animation(.easeInOut(duration: 0.3), value: isCurrentIndex)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                updateFrames(index: index, frame: proxy.frame(in: .global))
                            }
                            .onChange(of: proxy.frame(in: .global)) { frame in
                                updateFrames(index: index, frame: frame)
                            }
                    })
                    .applyWidthScaling(widthScaleMode)
                    .alignmentGuide(.horizontalCenterAlignment,
                                    isActive: shouldAlign(on: index)) { dimensions in
                        dimensions[HorizontalAlignment.center]
                    }
                }
            }
        }
        .onAppear {
            // This will ensure that frames is updated
            self.frames = Array(repeating: .zero, count: data.count)
            // Sometimes when hidding collection data, if currentPosition was at the last element,
            // currenPosition might hold an old value and doesn't udpate. The logic bellow ensure
            // currentPosition will be in the same index as selectedIndex when it happens.
            if let selectedIndex, let currentPosition, Int(currentPosition.rounded()) > selectedIndex {
                self.currentPosition = CGFloat(selectedIndex)
            }
        }
    }

    private var xOffset: CGFloat {
        guard
            let currentPosition = currentPosition,
            let currentIndex = currentIndex,
            !data.isEmpty,
            let lastFrame = frames.last
        else {
            return .zero
        }
        
        let flooredCurrentPosition = Int(currentPosition)
        
        let frameMaxX: CGFloat
        if flooredCurrentPosition < frames.count - 1 {
            frameMaxX = frames[boundedIndex(flooredCurrentPosition + 1)].midX
        } else {
            frameMaxX = lastFrame.midX + lastFrame.width
        }
        let frameMinX = frames[boundedIndex(flooredCurrentPosition)].midX

        let frameOffsetPercent: CGFloat
        if let alignmentIndex {
            frameOffsetPercent = currentPosition - CGFloat(alignmentIndex)
        } else {
            frameOffsetPercent = currentPosition - CGFloat(currentIndex)
        }

        return (frameMaxX - frameMinX) * frameOffsetPercent
    }

    private var currentIndex: Int? {
        guard let currentPosition = currentPosition else {
            return selectedIndex
        }
        return boundedIndex(Int(currentPosition.rounded()))
    }

    private var tabWidth: CGFloat? {
        guard let currentPosition = currentPosition else {
            return nil
        }
        let initialIndex = boundedIndex(Int(currentPosition))
        let endIndex = boundedIndex(Int(ceil(currentPosition)))
        return frames[initialIndex].width
            .interpolate(
                to: frames[endIndex].width,
                percent: currentPosition.truncatingRemainder(dividingBy: 1.0)
            )
    }

    private func isCurrentIndex(index: Int) -> Bool {
        currentIndex == index
    }

    private func shouldAlign(on index: Int) -> Bool {
        return alignmentIndex == index
    }

    private var alignmentIndex: Int? {
        guard
            let currentPosition = currentPosition,
            !data.isEmpty
        else {
            return currentIndex
        }

        let flooredCurrentPosition = Int(currentPosition)

        let currentIndex = boundedIndex(flooredCurrentPosition)
        let currentWidth = frames[currentIndex].width
        let nextIndex = boundedIndex(flooredCurrentPosition + 1)
        let nextWidth = frames[nextIndex].width

        // Tab indicator will align on the Tab with the larger width to prevent
        // the Tab sizes from being affected by the indicator's size.
        if currentWidth >= nextWidth {
            return currentIndex
        } else {
            return nextIndex
        }
    }

    private func boundedIndex(_ index: Int) -> Int {
        max(.zero, min(frames.count - 1, index))
    }

    private func updateFrames(index: Int, frame: CGRect) {
        if index >= frames.count {
            // When manipulating data collection (hiding and showing), frames array
            // is being updated while SwiftUI is in the middle of a rendering pass
            // that have more data collection than frames
            // so this is a way of preventing a crash.
            frames.append(frame)
        } else {
            frames[index] = frame
        }
    }
}

private struct Constants {
    static let horizontalTabSpacing: CGFloat = Layout.padding(3.5)
}

extension HorizontalAlignment {
    
    private enum CenterAlignmentID: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            return dimension[HorizontalAlignment.center]
        }
    }
    
    static var horizontalCenterAlignment: HorizontalAlignment {
        HorizontalAlignment(CenterAlignmentID.self)
    }
}

extension View {
    @ViewBuilder
    func alignmentGuide(_ alignment: HorizontalAlignment, isActive: Bool, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }

    @ViewBuilder
    func alignmentGuide(_ alignment: VerticalAlignment, isActive: Bool, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }
}
