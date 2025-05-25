//
//  ContentView.swift
//  ColorCalc
//
//  Created by Zeedan Feroz Khan on 5/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = FrameHandler()
    
    var body: some View {
        FrameView(image: model.frame)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
