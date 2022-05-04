//
//  Inspection.swift
//  DemoZoomScrollView (iOS)
//
//  Created by Jordy van Kuijk on 04/05/2022.
//

import SwiftUI

struct Inspection: Identifiable {
    let id: Int
    let xPosition: CGFloat
    let yPosition: CGFloat
    
    init(id: Int, xPosition: CGFloat = CGFloat.random(in: 100...2000), yPosition: CGFloat = CGFloat.random(in: 100...2000)) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
    }
}
