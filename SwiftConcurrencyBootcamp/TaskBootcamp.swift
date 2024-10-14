//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 14.10.2024.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func downloadImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = handleResponse(data: data, response: response)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func downloadImage2() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = handleResponse(data: data, response: response)
            }
        } catch {
            print(error.localizedDescription)
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

struct TaskBootcamp: View {
    
    @StateObject private var vm = TaskViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            if let image2 = vm.image2 {
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        // MARK: SwiftUI automaticlly cancel the task if view dissappear before the action complete.
        .task {
            await  vm.downloadImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
            // MARK: in this task downloadImage2 will wait for finish downloadImage
//            Task {
//                await vm.downloadImage()
//                await vm.downloadImage2()
//            }
            
            
            // MARK: know it will load at the same time
//            fetchImageTask = Task {
//                await vm.downloadImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await vm.downloadImage2()
//            }
            
            // MARK: TASK Priorties
//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("high: \(Thread.current), \(Task.currentPriority)")
//            }
//            
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current), \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("medium: \(Thread.current), \(Task.currentPriority)")
//            }
//           
//            Task(priority: .utility) {
//                print("utility: \(Thread.current), \(Task.currentPriority)")
//            }
//            
//            Task(priority: .low) {
//                print("low: \(Thread.current), \(Task.currentPriority)")
//            }
//            
//            Task(priority: .background) {
//                print("background: \(Thread.current), \(Task.currentPriority)")
//            }
        }
    }
}

#Preview {
    TaskBootcamp()
}
