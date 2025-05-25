//
//  ContentView.swift
//  ColorCalc
//
//  Created by Zeedan Feroz Khan on 5/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = FrameHandler()
    @State private var isCapturing = false
    @State private var isRecording = false
    @State private var showChart = false

    var body: some View {
        ZStack {
            FrameView(image: model.frame)
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                Button(action: {
                    if isRecording {
                        isCapturing = false
                        showChart = true
                    } else {
                        model.startCapturing()
                        isCapturing = true
                        showChart = false
                    }
                    isRecording.toggle()
                }) {
                    Text(isRecording ? "Stop" : "Record")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(isRecording ? Color.gray : Color.red)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 40)
            }
            if showChart {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
