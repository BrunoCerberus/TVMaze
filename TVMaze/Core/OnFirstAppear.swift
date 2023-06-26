//
//  OnFirstAppear.swift
//  TVMaze
//
//  Created by bruno on 26/06/23.
//

import SwiftUI

private struct OnFirstAppear: ViewModifier {
    let perform: () -> Void

    @State private var firstTime = true

    func body(content: Content) -> some View {
        content.onAppear {
            if firstTime {
                firstTime = false
                perform()
            }
        }
    }
}

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(perform: perform))
    }
}


struct Child: View {
    var body: some View {
        Color.red
            .onFirstAppear {
                print("Child.onFirstAppear()")
            }
            .navigationTitle("Child")
    }
}



struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink("Child", destination: Child())
                .navigationTitle(Text("Parent"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
