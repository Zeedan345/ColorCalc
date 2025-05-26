//
//  ChartView.swift
//  ColorCalc
//
//  Created by Zeedan Feroz Khan on 5/26/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    let data: [Double]
    let onClose: () -> Void
    var body: some View {
        VStack {
            Text("Average Green Intensity Over Time")
                .font(.headline)
                .padding()
            Chart {
                ForEach(data.indices, id: \.self) { i in
                    LineMark(x: .value("Frame", i), y: .value("Green", data[i]))}
            }
            .frame(height: 300)
            .padding()
            
            Button("Close Chart") {
                onClose()
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

