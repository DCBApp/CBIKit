//
//  CBIRenderImage.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import Foundation
import MetalKit

public class CBIRenderImage:CBIRender{
    
    
    override init(mtkView:MTKView) {
        super.init(mtkView: mtkView)
        configureShader(vertexShader: "imageVertexShader", fragmentShader: "imageFragmentShader")
        configurePipelineState(mtkView: mtkView)
        if let cgImage = UIImage(named: "image")?.cgImage {
            do{
                _texture = try sharedContext.textureLoader.newTexture(cgImage:cgImage , options: [MTKTextureLoader.Option.SRGB : false])
            }catch{
                assert(false, "\(error)")
            }
        }else{
            assert(false, "cgImage is  nil")
        }
        let viewportSizeWidth = Float(_viewportSize.x)/2
        let vertices : [CBIImageVertex] = [
            CBIImageVertex(position: vector_float2( viewportSizeWidth,-viewportSizeWidth),  textureCoordinate:vector_float2(1,1)),
            CBIImageVertex(position: vector_float2(-viewportSizeWidth,-viewportSizeWidth),  textureCoordinate:vector_float2(0,1)),
            CBIImageVertex(position: vector_float2( viewportSizeWidth, viewportSizeWidth),  textureCoordinate:vector_float2(0,0)),
            CBIImageVertex(position: vector_float2(-viewportSizeWidth, viewportSizeWidth),  textureCoordinate:vector_float2(1,0))
        ]
         _vertexBuffer = sharedContext.device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<CBIVertex>.size, options: MTLResourceOptions.storageModeShared)
    }
}

