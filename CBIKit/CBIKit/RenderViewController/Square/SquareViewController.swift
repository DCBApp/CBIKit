//
//  RenderViewController.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import MetalKit
import simd
class SquareViewController: UIViewController {
    private var _view:MTKView?
    private var _render:CBIRenderSquare?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let mtkView = view as? MTKView{
            _view = mtkView
            _view?.device = sharedContext.device
            _render = CBIRenderSquare(mtkView: mtkView)
            _render?.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
            _view?.delegate = _render
            
        }else{
            assert(false, "_view is nil")
        }

        
    }

}

