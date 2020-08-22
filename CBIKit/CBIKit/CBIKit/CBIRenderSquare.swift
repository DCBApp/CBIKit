//
//  CBIRender.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import Foundation
import MetalKit

public class CBIRenderSquare:CBIRender{
    
    override init(mtkView:MTKView) {
        super.init(mtkView: mtkView)
        configureShader(vertexShader: "vertexShader", fragmentShader: "fragmentShader")
        configurePipelineState(mtkView: mtkView)
        let viewportSizeWidth = Float(viewportSize.x)/2
        let vertices : [CBIVertex] = [
            CBIVertex(position: vector_float2( viewportSizeWidth,-viewportSizeWidth), color: vector_float4(1,0,0,1)),
            CBIVertex(position: vector_float2(-viewportSizeWidth,-viewportSizeWidth), color: vector_float4(1,0,0,1)),
            CBIVertex(position: vector_float2( viewportSizeWidth, viewportSizeWidth), color: vector_float4(1,0,0,1)),
            CBIVertex(position: vector_float2(-viewportSizeWidth, viewportSizeWidth), color: vector_float4(1,0,0,1))
        ]
        vertexBuffer = sharedContext.device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<CBIVertex>.size, options: MTLResourceOptions.storageModeShared)
    }
}

