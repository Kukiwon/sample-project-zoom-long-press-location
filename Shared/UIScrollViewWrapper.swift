//
//  UIScrollViewWrapper.swift
//  lingq-5
//
//  Created by Timothy Costa on 2019/07/05.
//  Copyright © 2019 timothycosta.com. All rights reserved.
//

import SwiftUI
import UIKit

final class UIScrollViewWrapper<Content: View>: UIViewControllerRepresentable {

    var content: () -> Content
    private var vc: UIScrollViewViewController!
    
    @Binding var scaleFactor: CGFloat
    let onLongPress: (CGPoint) -> Void

    init(scaleFactor: Binding<CGFloat>, onLongPress: @escaping (CGPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        _scaleFactor = scaleFactor
        self.onLongPress = onLongPress
    }

    func makeUIViewController(context: Context) -> UIScrollViewViewController {
        let vc = UIScrollViewViewController()
        let view = AnyView(self.content())
        vc.hostingController.rootView = view
        vc.scrollView.delegate = context.coordinator
        vc.onLongPress = onLongPress
        self.vc = vc
        return vc
    }

    func updateUIViewController(_ viewController: UIScrollViewViewController, context: Context) {
        viewController.hostingController.rootView = AnyView(self.content())
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: UIScrollViewWrapper
        
        init(_ parent: UIScrollViewWrapper) {
            self.parent = parent
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
            withAnimation(.spring()) {
                let roundedScaleFactor = round(scrollView.zoomScale * 10) / 10
                if parent.scaleFactor != roundedScaleFactor {
                    parent.scaleFactor = roundedScaleFactor
                }
            }
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return parent.vc.hostingController.view
        }
    }
}

class UIScrollViewViewController: UIViewController {

    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.minimumZoomScale = 0.2
        v.maximumZoomScale = 5
        v.bouncesZoom = true
        return v
    }()

    var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
    
    private var viewDidSetZoomScale = false
    var onLongPress: ((CGPoint) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.pinEdges(of: self.scrollView, to: self.view)
        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.pinEdges(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)
        self.hostingController.view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setZoomScale()
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.hostingController.view.alpha = 1
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPress(gesture:)))
            self.hostingController.view.addGestureRecognizer(longPressGestureRecognizer)
        }
    }

    func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
    }
    
    func setZoomScale() {
        scrollView.minimumZoomScale = 0.1
        scrollView.zoomScale = 1
    }
    
    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let view = gesture.view else { break }
            let location = gesture.location(in: view)
            
            /* Correct the offset based on the marker width and height. */
            let pinPointWidth = InspectionMarkerView.inspectionWidth
            let pinPointHeight = InspectionMarkerView.inspectionHeight
            let x = location.x - (pinPointWidth / 2)
            let y = location.y - pinPointHeight
            let finalLocation = CGPoint(x: x, y: y)
            
            self.onLongPress(finalLocation)
        default:
            break
        }
    }
}
