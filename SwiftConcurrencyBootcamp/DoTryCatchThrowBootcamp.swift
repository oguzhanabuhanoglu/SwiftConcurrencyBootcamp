//
//  DoTryCatchThrowBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 13.10.2024.
//

import SwiftUI

class DoTryCatchThrowManager {
    
    static let instance = DoTryCatchThrowManager()
    var isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Title", nil)
        } else {
            return (nil, URLError(.badServerResponse))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Title")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New Title"
        } else {
            throw URLError(.networkConnectionLost)
        }
    }
    
    func getTitle4() throws -> String {
//        if isActive {
//            return "New Title"
//        } else {
            throw URLError(.networkConnectionLost)
//        }
    }
    
    
}

class DoCatchTryThrowViewModel: ObservableObject {
    
    @Published var text: String = "Starting Text"
    let manager = DoTryCatchThrowManager.instance
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            text = newTitle
        } else if let error = returnedValue.error{
            text = error.localizedDescription
        }
         */
        
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let title):
            text = title
        case .failure(let error):
            text = error.localizedDescription
        }
         */
        
        /*
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        } catch let error {
            self.text = error.localizedDescription
        }
         */
        
        
        // If try is optiona we do not have to handle error.
        let newTitle = try? manager.getTitle4()
        if let newTitle = newTitle {
            self.text = newTitle
        }
        
        
        // MARK: You can use more then one try in do block. If one of them throws an error it is immidiatly catch the error. The inside of the do statement runs sequentially. If there in an optional try in do statement it does not throw error so still try the other ones.
        
        // MARK: Almost everytime when we have func with a throws, we will need use do try catch block.
        
        
    }
    
    
}

struct DoCatchTryThrowBootcamp: View {
    
    @StateObject var vm = DoCatchTryThrowViewModel()
    
    var body: some View {
        Text(vm.text)
            .font(.title)
            .foregroundStyle(.white)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
        
    }
}

#Preview {
    DoCatchTryThrowBootcamp()
}
