//
//  CacheImageView.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import SwiftUI
import Kingfisher

struct CacheImageView: View {
    
    private enum ImageLoadState {
        case loading
        case loaded
        case failed
    }
    
    typealias ResultClojure = (Result<RetrieveImageResult, KingfisherError>) -> Void
    
    private let isTest: String = ProcessInfo.processInfo.environment["ISTEST"] ?? ""
    
    private(set) var fallback: Image = .defaultPlaceHolder
    private(set) var resultClojure: ResultClojure?
    
    @State private var state: ImageLoadState = .loading
    
    private let processingQueue: DispatchQueue = .global(qos: .background)
    private let source: Source
    
    init(
        url: String,
        fallback: Image = .defaultPlaceHolder,
        resultClojure: ResultClojure? = nil
    ) {
        self.fallback = fallback
        self.resultClojure = resultClojure
        
        if let typedUrl: URL = URL(string: isTest.isEmpty ? url : "noImage") {
            self.source = .network(KF.ImageResource(downloadURL: typedUrl))
        } else {
            self.source = .network(KF.ImageResource(downloadURL: URL(fileURLWithPath: "")))
            self.state = .failed
        }
    }
    
    var body: some View {
        ZStack {
            KFImage(source: source)
                .scaleFactor(UIScreen.main.scale)
                .cacheOriginalImage()
                .placeholder {
                    ProgressView()
                        .scaledToFit()
                }
                .cancelOnDisappear(true)
                .processingQueue(.dispatch(processingQueue))
                .diskCacheExpiration(.days(30))
                .fade(duration: 0.25)
                .startLoadingBeforeViewAppear()
                .resizable()
                .onProgress { _, _ in
                    state = .loading
                }
                .onSuccess {
                    state = .loaded
                    resultClojure?(.success($0))
                }
                .onFailure {
                    state = .failed
                    resultClojure?(.failure($0))
                }
                .isHidden(state == .failed)
            
            if state == .failed {
                Text("NO IMAGE")
                    .font(.primary(.large))
                    .foregroundColor(.white)
            }
        }
    }
}
