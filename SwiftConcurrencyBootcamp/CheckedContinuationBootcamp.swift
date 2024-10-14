//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 14.10.2024.
//

import SwiftUI

class CheckedContinuationDataManager {
    
    static let instance = CheckedContinuationDataManager()
    
    func downloadImage(url: URL) async throws -> Data {
        do {
            let (data, _)  = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    // if the API can not work with async use continuation to make it async.
    // Convert non async code into async code.
    func downloadImage2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
        
    }
    
    
    
}

class CheckedContinuationViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let manager = CheckedContinuationDataManager.instance
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        
        do {
            let image = try? await UIImage(data: manager.downloadImage2(url: url))
            if let image = image {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
    }
}

struct CheckedContinuationBootcamp: View {
    
    @StateObject var vm = CheckedContinuationViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .task {
            await vm.getImage()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
