//
//  SheetViewModel.swift
//  DiviD
//
//  Created by Jordy van Kuijk on 15/02/2022.
//

import Foundation
import UIKit
import Kingfisher
import SwiftUI
import Combine

extension SheetView {

    class ViewModel: ObservableObject {
        
        @Published var sheetImage: UIImage?
        @Published var inspections: [Inspection] = (0...100).map { Inspection.init(id: $0) }
            
        init() {
            self.loadImage()
        }
    
        var sheetName: String {
            "Demo Sheet"
        }
        
        var sheetId: Int {
            1
        }
        
        func loadImage() {
            self.sheetImage = UIImage(named: "sheet_hd")
        }
        
        func onInspectionPointCreated(location: CGPoint) {
            inspections += [Inspection(id: inspections.count, xPosition: location.x, yPosition: location.y)]
        }
    }
}

