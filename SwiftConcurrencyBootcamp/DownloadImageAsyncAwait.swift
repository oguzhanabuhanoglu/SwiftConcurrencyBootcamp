//
//  DownloadImageAsyncAwait.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 13.10.2024.
//

import SwiftUI
import Combine

class AsyncAwaitManager {
    
    static let shared = AsyncAwaitManager()
    let url = URL(string: "https://picsum.photos/200")!
    
    // MARK: DOWNLOAD IMAGE W/ESCAPING
    /*
    func downloadImageWithEscaping(completionHandler: @escaping (_ image: UIImage?,_ error: Error?) -> Void) {

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let image = self?.handleResponse(data: data, response: response) {
                completionHandler(image, error)
            }
        }
        .resume()
    }
     */
    
    // MARK: DOWNLOAD IMAGE W/COMBINE
    /*
    func downloadImageWithCombine() -> AnyPublisher<UIImage?, Error> {
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    */
    
    func downloadImageWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    
}

class AsyncAwaitViewModel: ObservableObject {
    
    @Published var manager = AsyncAwaitManager.shared
    @Published var image: UIImage? = nil
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage() async {
        // MARK: ESCAPING & COMBINE
        /*
        manager.downloadImageWithEscaping { [weak self] image, error in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        
        manager.downloadImageWithCombine()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
        */
        
        let image = try? await manager.downloadImageWithAsync()
        // to get ui work on main thread like dispatchQueue.main
        await MainActor.run {
            self.image = image
        }
        
    }
    
}



struct DownloadImageAsyncAwaitBootcamp: View {
    
    @StateObject var vm = AsyncAwaitViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .scaledToFill()
            }
        }
        .onAppear {
            Task {
                await vm.fetchImage()
            }
            
        }
    }
}

#Preview {
    DownloadImageAsyncAwaitBootcamp()
}
