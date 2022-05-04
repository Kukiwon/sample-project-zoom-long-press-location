//
//  ContentView.swift
//  Shared
//
//  Created by Jordy van Kuijk on 04/05/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SheetView(viewModel: .init())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
