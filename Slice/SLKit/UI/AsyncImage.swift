//
//  AsyncImage.swift
//  Slice
//
//  Created by Artyom Batura on 3.12.21.
//

import Foundation
import SwiftUI
import Combine
import SDWebImage

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    private var url: URL? = nil
    
    init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:),
        shouldShowSkeleton: Bool? = nil
    ) {
        self.url = url
        self.placeholder = placeholder()
        self.image = image
        
        _loader = StateObject(
            wrappedValue: ImageLoader(
                url: url ?? URL(string: "http://")!
            )
        )
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
            .onChange(of: url, perform: { url in
                loader.url = url ?? URL(string: "http://")!
                loader.load()
            })
            .redacted(reason: loader.isLoading ? .placeholder : [])
    }
    
    @ViewBuilder
    private var content: some View {
        if loader.image != nil {
            image(loader.image!)
                .resizable()
        } else {
            placeholder
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    @Published private(set) var isLoading = false
    
    var url: URL

    private static let imageProcessingQueue = DispatchQueue(
        label: "image-processing", qos: .userInitiated, attributes: .concurrent)

    init(url: URL) {
        self.url = url
    }

    deinit {
        cancel()
    }

    func load() {
        guard !isLoading else { return }
        
        onStart()
        
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, data, error, cacheType, finished, url in
            self.onFinish()

            self.image = image
        }
    }

    func cancel() {
        SDWebImageManager.shared.cancelAll()
    }

    private func onStart() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
    }

    private func onFinish() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
        }
    }
}
