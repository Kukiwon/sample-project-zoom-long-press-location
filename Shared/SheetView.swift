//
//  SheetView.swift
//  DiviD
//
//  Created by Jordy van Kuijk on 15/02/2022.
//

import SwiftUI
import UIKit
import Kingfisher
import Combine

struct SheetView: View {
        
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            VStack {
                if let image = viewModel.sheetImage {
                    PinchPanSheetView(
                        image: image,
                        onInspectionCreated: viewModel.onInspectionPointCreated(location:),
                        inspections: viewModel.inspections
                    )
                }
            }
        }
        .navigationTitle(viewModel.sheetName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(viewModel: .init())
    }
}

struct PinchPanSheetView: View {
    
    @State var scaleFactor: CGFloat = 1
    
    let image: UIImage
    var onInspectionCreated: (CGPoint) -> ()
    let inspections: [Inspection]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            UIScrollViewWrapper(scaleFactor: $scaleFactor, onLongPress: onInspectionCreated) {
                ZStack(alignment: .topLeading) {
                    Image(uiImage: image)
                    ForEach(inspections) { inspection in
                        InspectionMarkerView(
                            scaleFactor: scaleFactor,
                            xLocation: inspection.xPosition,
                            yLocation: inspection.yPosition,
                            iconName: "ip_open_filled")
                    }
                }
            }
            .clipped()
            Text("Scale: \(Decimal(scaleFactor).description)")
                .font(.headline)
                .foregroundColor(.blue)
                .allowsHitTesting(false)
        }
    }
}


