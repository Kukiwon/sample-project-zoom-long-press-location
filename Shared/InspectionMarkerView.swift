//
//  InspectionMarkerView.swift
//  DiviD
//
//  Created by Jordy van Kuijk on 16/02/2022.
//

import SwiftUI

struct InspectionMarkerView: View {
    
    static let inspectionHeight = 42.0
    static let inspectionWidth = 32.0
    
    let scaleFactor: CGFloat
    let xLocation: CGFloat
    let yLocation: CGFloat
    let iconName: String
        
    var showLabel: Bool {
        return scaleFactor >= 1.5
    }
    
    var scale: CGFloat {
        1 / scaleFactor
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(iconName)
                .resizable()
                .frame(width: Self.inspectionWidth, height: Self.inspectionHeight)
        }
        .scaleEffect(scale, anchor: .init(x: 0.5, y: 1))
        .offset(
            x: xLocation,
            y: yLocation
        )
    }
}
