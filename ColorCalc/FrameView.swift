//
//  FrameView.swift
//  ColorCalc
//
//  Created by Zeedan Feroz Khan on 5/25/25.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
        } else {
            Color.black
        }
    }
}

#Preview {
    FrameView()
}
