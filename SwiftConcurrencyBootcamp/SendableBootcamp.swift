//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 15.10.2024.
//

import SwiftUI

struct StructUserInfo: Sendable {
    let name: String
}

final class ClassUserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: ".com.MyApp")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
    
}

actor SendableBootcampManager {
    
    func updateDatabase(userInfo: StructUserInfo) {
        
    }
    
    func updateDatabase(userInfo: ClassUserInfo) {
        
    }
}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = SendableBootcampManager()
    
    func updateUserInfo() async {
        let info = StructUserInfo(name: "struct")
        await manager.updateDatabase(userInfo: info)
    }
    
    func updateUserInfo2() async {
        let info = ClassUserInfo(name: "class")
        await manager.updateDatabase(userInfo: info)
    }
}


struct SendableBootcamp: View {
    
    @StateObject var vm = SendableBootcampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SendableBootcamp()
}
