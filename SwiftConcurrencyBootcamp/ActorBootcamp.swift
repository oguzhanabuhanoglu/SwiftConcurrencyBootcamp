//
//  ActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 15.10.2024.
//

/*
1- What is the problem thats actors are solving ?
 
 Actors and classes are stored in the heap the only big difference is the actors are going to be thread safe. If the differents threads need access to same class in heap app can be crash. But actors await for this kind of situations by default.

// How was this problem solved prior to actors ?
  
*/
import SwiftUI

class MyDataManager {

    static let instance = MyDataManager()
    var dataArray: [String] = []
    private let lock = DispatchQueue(label: ".com.MyApp.ActorBootcamp")
    
    // That's how was problem solved before the actor.
    // functions are lining up ins same thread asynchronously.
    func getRandomData(completionHandler: @escaping (_ data: String) -> ()) {
        lock.async {
            self.dataArray.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.dataArray.randomElement()!)
        }
    }
    
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    var dataArray: [String] = []
    
    func getRandomData() -> String? {
        self.dataArray.append(UUID().uuidString)
        print(Thread.current)
        return dataArray.randomElement()
    }
    
    nonisolated func getString() -> String {
        return "Non isolated doesnt need to await"
    }
}

struct HomeView: View {
    
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State var text: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
                .foregroundStyle(.black)
        }
        .onAppear(perform: {
            let string = manager.getString()
            
            let data = manager.getRandomData() // warning hear because this is not nonisolated we should call this function on background thread with Task.
        })
        .onReceive(timer, perform: { _ in
            // MARK: Without actor
//            DispatchQueue.global(qos: .background).async {
//                 manager.getRandomData(completionHandler: { data in
//                    DispatchQueue.main.async {
//                        self.text = data
//                    }
//                })
//            }
            
            // MARK: With Actor
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        })
            
    }
}

struct BrowseView: View {
    
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
                .foregroundStyle(.black)
        }
        .onReceive(timer) { _ in
            // MARK: Without actor
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { data in
//                    DispatchQueue.main.async {
//                        self.text = data
//                    }
//                }
//            }
            
            // MARK: With Actor
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
        }
    }
}


struct ActorBootcamp: View {
    var body: some View {
        TabView {
            Tab {
                HomeView()
            } label: {
                Image(systemName: "house.fill")
            }
            
            Tab {
                BrowseView()
            } label: {
                Image(systemName: "magnifyingglass")
            }

        }
    }
}

#Preview {
    ActorBootcamp()
}
