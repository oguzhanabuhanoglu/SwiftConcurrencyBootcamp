//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Oğuzhan Abuhanoğlu on 15.10.2024.
//

// MARK: NOTES AND DOCUMNETATİONS LINKS
/*
 ----------------------
 
 VALUE TYPE:
 - Struct, Enum, String, Int etc.
 - Stored in STACK!
 - Faster
 - Thread safe!
 - When you assign or pass value type a new copy of data is created.
 
 REFERENCE TYPE:
 - Class, Actor, Function
 - Stored in the HEAP!
 - Slower
 - NOT Thread safe!
 - When you assign or pass referenece to original instance will be created. (pointer)
 
 -----------------------
 
 STACK:
 - Store value type.
 - Each thread has it's own stack.

 
 HEAP:
 - Store reference type.
 - Shared across thread.

 ------------------------
 
 STRUCT:                           -> Views, DataModels,
 - Based on values
 - Can be mutated
 - Stored in the stack
 
 CLASS:                            -> ViewModels
 - Based on refences (instance)
 - Can not be mutated
 - Stored in the heap
 - Inherit from other classes
 
 
 ACTORS:                           -> Shared 'Manager' , 'DataStore'
 
 Actors and classes are stored in the heap the only big difference is the actors are going to be thread safe. If the differents threads need access to same class in heap app can be crash. But actors await for this kind of situations by default.
 
 --------------------------
 
 
 
 Some documentation about:
 Heap / stack
 Class / Struct
 ARC
 Threads
 

 Links:
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbk1FN29seFk1SUttdFIyYllIQlllSHYyLXZwZ3xBQ3Jtc0tsUVh2TGl0OEZjWHBhbGxVRkpWd3ZTOHpJeW02ci10emgya2oxbmZxQzFXLTRUOV9vUFkyVjhFZk1rdWtQY1JrRU8xQmFLSHZoZ2xPQ0pPWjNtSzRqdFlwclo1TGgzcThwMUw0MHNpTWtiekRfQ21mYw&q=https%3A%2F%2Fblog.onewayfirst.com%2Fios%2Fposts%2F2019-03-19-class-vs-struct%2F&v=-JLenSTKEcA
 
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbXhOalhoNTZUWmVOdVNfakh3TE40bE53WmYxZ3xBQ3Jtc0trVF9mYXJ2SXBiYzh2M212U3I1NVN5VmswUHJVUENYSmV6X1lXQTJZSFc2eUVERzlHM3dndDlDQ0R4TnFCa0tFaDdqOHp0QkxHcnJ5cmhIbzZtNHNOZHBBRmgxUkd6NkxWT00wT21lNlVLVHdxcUduZw&q=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F24217586%2Fstructure-vs-class-in-swift-language&v=-JLenSTKEcA
 
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqblBqRFVQZVdOa0VRcDctTkxud2otMnJibElXQXxBQ3Jtc0tuQW1TVUU4RG5aOWFDR2QtWVR1Wkgyc0FVU0RkSnVHSURuejRjVjAxeEZxTGpNLS01VkxlTVNXYk1EdzNzT1ByYzV3Y2tLLVhVUHhwVDdMaVduUWhBaDF2Zk52SlNQdFE5cXd2eTdsUnpfLThxVEhyTQ&q=https%3A%2F%2Fmedium.com%2F%40vinayakkini%2Fswift-basics-struct-vs-class-31b44ade28ae&v=-JLenSTKEcA
 
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbTV6bUhFaGxJc3M0aTIzb1hNNjJQd0VHbzJUQXxBQ3Jtc0tuRnhCNTRjRGM5dnlHRmVCeDlXMDZjN2pkR0pMVlpMZ3JXa1ptcHgxeElXZ3V2b3JTWlU4QmVyc21IRFN6LUdsWmtWU1k0TS11V040WXJDNVhNbldzdGFGbDJlSUdyT0J3OFpLNGFLSEwzb29TenI1Yw&q=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F24217586%2Fstructure-vs-class-in-swift-language%2F59219141%2359219141&v=-JLenSTKEcA
 
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbURNaUs3ei1ib3QwX0pZb1lGd21NZ0RxQXBYd3xBQ3Jtc0trWmdsdXpCZVlLeHVWdzVfbS1jdkpDYWdrNHdHMGpwMGhFVXZnU2dWd2tOekUyUk1LNUhRVGlLT0lMMjdxcFBpT0xOeTV6RWJaNG9NXzJTam9tRUlfMDV1NGRwT1pCU1cwWGk4OTZyTDktajlfVlFVTQ&q=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F27441456%2Fswift-stack-and-heap-understanding&v=-JLenSTKEcA
 
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbndLSFhSWW9UTFJ3QUswdWdWdU1oX19ZRllyd3xBQ3Jtc0ttSnVNcWNEQ25XSGpoSzFyNTdha1VIXzVqQkhueXA2NklHZ1JOOVJTZVVoTjUzZDFBaW1uQ0JMUlIyWjJrYl9meU5CUlBVajgzOGx3aHFMVWFrRDBiUWxTdWV2YjhHc0U4U0VWSmN1aXlKRjJ1bGFiUQ&q=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F24232799%2Fwhy-choose-struct-over-class%2F24232845&v=-JLenSTKEcA
 
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqblhxX3NmQ0pBdC1FSTNNdlBCNXpBLU1XWW1jUXxBQ3Jtc0trc2xkZjEwYWkzN09KWVAydGljcnhIZTNENDdDWkgyemtYSC1hQnNDeTRRR3Y4OTROLUpDSHZxWnl1THVTU044eGxrZEc2djRBcS0tLTB0a1g4RlVDQzloVWZDdm1QVFRoYlJic3gwRWYxTzlCQW9Taw&q=https%3A%2F%2Fwww.backblaze.com%2Fblog%2Fwhats-the-diff-programs-processes-and-threads%2F&v=-JLenSTKEcA
 
 https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbkJ3aDREVkRpMDVUQmtnOWF5aGVCcHE3UWhkQXxBQ3Jtc0tsRUZXSFRGeVozdTdfM0hSTk5xRE9xOEx6N1BkaXp5UnFqRW55V1A3eVdnYjlUaHlib2wzb2NSbnBoMXNZbFFjOHkzYTZjN05sREZ5RmZqaGRuUXg5OTJrcnM5LWVMQkhOVlc4b0J5UUZteUhWYThKSQ&q=https%3A%2F%2Fmedium.com%2Fdoyeona%2Fautomatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99&v=-JLenSTKEcA
 
 */


import SwiftUI

actor StructClassActorBootcampManager {
    
}

class StructClassActorBootcampViewModel: ObservableObject {
    
}

struct StructClassActorBootcamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                runTest()
            }
    }
}

#Preview {
    StructClassActorBootcamp()
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        structTest1()
        addDivider()
        classTest1()
        addDivider()
        actorTest1()
        
        addDivider()
        
        structTest2()
        addDivider()
        classTest2()
        
    }
    
    private func addDivider() {
        print("""
    
    ------------------------------------------------
    
    """)
    }
    
    private func structTest1() {
        print("STRUCT TEST")
        
        let objectA = MyStruct(title: "Starting title")
        print("objectA title: \(objectA.title)")
        
        print("Pass the VALUE of obhectA to objectB")
        
        var objectB = objectA
        print("objectB title: \(objectB.title)")
        
        
        
        objectB.title = "New Title"
        print("objectB title is changed")
        print("objectA title: \(objectA.title)")
        print("objectB title: \(objectB.title)")
    }
    
    private func classTest1() {
        print("CLASS TEST")
        
        let objectA = MyClass(title: "Starting title")
        print("objectA title: \(objectA.title)")
        
        print("Pass the REFERENCE of obhectA to objectB")
        
        let objectB = objectA
        print("objectB title: \(objectB.title)")
        
        
        
        objectB.title = "New Title"
        
        print("objectB title is changed")
        print("objectA title: \(objectA.title)")
        print("objectB title: \(objectB.title)")
    }
    
    private func actorTest1() {
        Task {
            print("ACTOR TEST")
            
            let objectA = MyActor(title: "Starting title")
            await print("objectA title: \(objectA.title)")
            
            print("Pass the REFERENCE of obhectA to objectB")
            
            let objectB = objectA
            await print("objectB title: \(objectB.title)")
            
            
            
            //await objectB.title = "New Title"
            await objectB.updateTitle(newTitle: "New Title")
            
            print("objectB title is changed")
            await print("objectA title: \(objectA.title)")
            await print("objectB title: \(objectB.title)")
        }
        
    }
    
    
}

struct MyStruct {
    var title: String
}

// immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    var title: String
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}


class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}


extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("STRUCT TEST 2")
        
        var struct1 = MyStruct(title: "Title1")
        print("struc1: \(struct1.title)")
        struct1.title = "Title2"
        print("struc1: \(struct1.title)")
        
        var struct2 = CustomStruct(title: "Title1")
        print("struct2 \(struct2.title)")
        struct2 = CustomStruct(title: "Title2")
        print("struc2: \(struct2.title)")
        
        var struct3 = CustomStruct(title: "Title1")
        print("struct2: \(struct3.title)")
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("struct2: \(struct3.title)")
        
        var struct4 = MutatingStruct(title: "Title1")
        print("struct4: \(struct4.title)")
        struct4.updateTitle(newTitle: "Title2")
        print("struct4: \(struct4.title)")
        
    }
    
    private func classTest2() {
        print("CLASS TEST 2")
        
        // we can create class object with a let constans. Because we are changing just value of the object we are not mutating the object.
        let class1 = MyClass(title: "Title")
        print("class1: \(class1.title)")
        class1.title = "Title2"
        print("class1: \(class1.title)")
        
        let class2 = MyClass(title: "Title1")
        print("class2: \(class2.title)")
        class2.updateTitle(newTitle: "Title2")
        print("class2: \(class2.title)")
    }
}
