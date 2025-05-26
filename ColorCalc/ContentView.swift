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
                if !showChart {
                    Button(action: {
                        if isRecording {
                            model.stopCapturing()
                            showChart = true
                        } else {
                            model.startCapturing()
                        }
                        isRecording.toggle()
                    }) {
                        Text(isRecording ? "Stop" : "Record")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(isRecording ? Color.gray : Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .padding(.bottom, 40)
                }
                else {
                    ChartView(data: model.greenValues.map(Double.init)){
                        isCapturing = false
                        showChart = false
                        model.resetGreenValues()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
