//
//  CBIImageView.swift
//  CBIKit
//
//  Created by Quinn on 2020/8/21.
//  Copyright © 2020 Quinn. All rights reserved.
//

import UIKit
import MetalKit
class CBIImageView: MTKView {
    private var render:CBIImage?
    var image:UIImage? {
        didSet{
            updateImage()
        }
    }
    convenience init(frame:CGRect,image:UIImage? = nil,device:MTLDevice? = nil) {
        self.init(frame:frame)
        if device == nil{
            self.device = sharedContext.device
        }
        if let img = image{
            self.render = CBIImage(mtkView: self,image:img)
        }
        self.render?.mtkView(self, drawableSizeWillChange: self.drawableSize)
        self.delegate = render
    }
    
    private func updateImage(){
        if let img = image{
            self.render?.updateImage(img: img)
        }
    }
}
