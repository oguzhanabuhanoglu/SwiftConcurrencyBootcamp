//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 13.10.2024.
//

import SwiftUI

class AsyncAwaitViewModell: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1: \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title2 = "Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)
                
                let title3 = "Title3: \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor() async {
        let author1 = "Author1: \(Thread.current)"
        dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "Author2: \(Thread.current)"
        await MainActor.run {
            dataArray.append(author2)
            
            let author3 = "Author3: \(Thread.current)"
            dataArray.append(author3)
        }
        
    }
    
    func addSomething() async {
        let something1 = "Something1: \(Thread.current)"
        dataArray.append(something1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something2 = "Something2: \(Thread.current)"
        await MainActor.run {
            dataArray.append(something2)
            
            let something3 = "Something3: \(Thread.current)"
            dataArray.append(something3)
        }
    }
    
    
}

struct AsyncAwaitBootcamp: View {
    
    @StateObject var vm = AsyncAwaitViewModell()
    
    var body: some View {
        List {
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
//            vm.addTitle()
//            vm.addTitle2()
            
            Task {
                await vm.addAuthor()
                await vm.addSomething()
                // we dont have to await seperatly fot both of them. it will be in another bootcamp topic.
            }
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
