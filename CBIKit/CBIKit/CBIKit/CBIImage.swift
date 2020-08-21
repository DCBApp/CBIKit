//
//  CBIRenderImage.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import Foundation
import MetalKit

public class CBIImage:CBIRender{
    
    init(mtkView:MTKView,image:UIImage) {
        super.init(mtkView: mtkView)
        configureShader(vertexShader: "imageVertexShader", fragmentShader: "imageFragmentShader")
        configurePipelineState(mtkView: mtkView)
        updateImage(img: image)
        let viewportSizeWidth = Float(_viewportSize.x)/2
        let textureVertices : [CBIImageVertex] = [
            CBIImageVertex(position: vector_float2(-viewportSizeWidth, -viewportSizeWidth),
                           textureCoordinate:vector_float2(1,1)),
            CBIImageVertex(position: vector_float2(-viewportSizeWidth, viewportSizeWidth),
                           textureCoordinate:vector_float2(1,0)),
            CBIImageVertex(position: vector_float2( viewportSizeWidth, -viewportSizeWidth),
                           textureCoordinate:vector_float2(0,1)),
            CBIImageVertex(position: vector_float2( viewportSizeWidth, viewportSizeWidth),
                           textureCoordinate:vector_float2(0,0))
        ]
        _vertexBuffer = sharedContext.device.makeBuffer(bytes: textureVertices,
                                                        length: textureVertices.count * MemoryLayout<CBIVertex>.size,
                                                        options: MTLResourceOptions.storageModeShared)
    }
    func updateImage(img:UIImage){
        if let cgImage = img.cgImage {
            do{
                _texture = try sharedContext.textureLoader.newTexture(cgImage:cgImage , options: [MTKTextureLoader.Option.SRGB : false])
            }catch{
                assert(false, "\(error)")
            }
        }else{
            assert(false, "cgImage is  nil")
        }
    }
}

