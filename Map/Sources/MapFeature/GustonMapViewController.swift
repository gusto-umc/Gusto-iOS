//
//  GustonMapViewController.swift
//  MapFeature
//
//  Created by 강동영 on 10/17/25.
//

import UIKit


final class GustoMapViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  deinit {
    print("deinit")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}


import SwiftUI

struct GustoMapRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = GustoMapViewController
  func makeUIViewController(context: Context) -> GustoMapViewController {
    let vc = GustoMapViewController()
    return vc
  }
  func updateUIViewController(_ uiViewController: GustoMapViewController, context: Context) {
    
  }
  func makeCoordinator() -> () {
    
  }
}
