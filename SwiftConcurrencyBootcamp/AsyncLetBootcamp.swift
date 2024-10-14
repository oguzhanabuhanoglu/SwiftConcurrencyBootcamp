//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 14.10.2024.
//

import SwiftUI

class AsyncLetViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    private let url = URL(string: "https://picsum.photos/200")!
    
    func fetchImage() async throws -> UIImage {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let image = handleResponse(data: data, response: response) else {
                throw URLError(.unknown)
            }
            return image
        } catch {
            throw error
        }
    }
    
    func handleResponse(data: Data?, response: URLResponse) -> UIImage? {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return UIImage(data: data)
    }
    
}

struct AsyncLetBootcamp: View {
    
    @StateObject var vm = AsyncLetViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                    }
                }
            }
            .navigationTitle("Async Let Bootcamp")
            .onAppear {
//                Task {
//                    let image1 = try await vm.fetchImage() 
//                    vm.images.append(image1)
//                    
//                    let image2 = try await vm.fetchImage()
//                    vm.images.append(image2)
//                    
//                    let image3 = try await vm.fetchImage()
//                    vm.images.append(image3)
//                    
//                    let image4 = try await vm.fetchImage()
//                    vm.images.append(image4)
//                }
                Task {
                    do {
                        // we can use async let instead of create more task to make few asycn job at the exatly same time.
                        async let fetchImage1 = vm.fetchImage()
                        async let fetchImage2 = vm.fetchImage()
                        async let fetchImage3 = vm.fetchImage()
                        async let fetchImage4 = vm.fetchImage()
                        
                        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                        vm.images.append(contentsOf: [image1, image2, image3, image4])
                    }
                }
            }
        }
        
        
        
    }
}

#Preview {
    AsyncLetBootcamp()
}
