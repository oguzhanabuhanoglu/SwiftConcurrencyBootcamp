//
//  TaskGroupBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 14.10.2024.
//

import SwiftUI

// MARK: MANAGER
class TaskGroupDataManager {
    
    static let instance = TaskGroupDataManager()
    
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings = [
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200"
        ]

        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            
            for url in urlStrings {
                group.addTask {
                    try? await self.downloadImages(urlString: url)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImages1 = downloadImages(urlString: "https://picsum.photos/200")
        async let fetchImages2 = downloadImages(urlString: "https://picsum.photos/200")
        async let fetchImages3 = downloadImages(urlString: "https://picsum.photos/200")
        async let fetchImages4 = downloadImages(urlString: "https://picsum.photos/200")
        
        var (image1, image2, image3, image4) = await (try fetchImages1, try fetchImages2, try fetchImages3, try fetchImages4)
        return [image1, image2, image3, image4]
        
    }
        
    
    func downloadImages(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let image = handleResponse(data: data, response: response) else { throw URLError(.unknown) }
            return image
        } catch {
            throw error
        }
    }
    
    
    func handleResponse(data: Data?, response: URLResponse) -> UIImage? {
        guard let data = data,
              let response = response as?  HTTPURLResponse,
              response.statusCode >= 200, response.statusCode < 300 else {
            return nil
        }
        return UIImage(data: data)
    }
    
}


// MARK: VIEWMODEL
class TaskGroupViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    private let manager = TaskGroupDataManager.instance
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
    
}




// MARK: VIEW
struct TaskGroupBootcamp: View {
    
    @StateObject var vm = TaskGroupViewModel()
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
            .navigationTitle("Task Group Bootcamp")
            .task {
                await vm.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupBootcamp()
}
