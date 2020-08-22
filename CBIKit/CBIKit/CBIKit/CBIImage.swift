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
        let viewportSizeWidth = Float(viewportSize.x)/2
        let viewportSizeHeight = Float(viewportSize.y)/2

        let textureVertices : [CBIImageVertex] = [
            CBIImageVertex(position: vector_float2(-viewportSizeWidth, -viewportSizeHeight),
                           textureCoordinate:vector_float2(1,1)),
            CBIImageVertex(position: vector_float2(-viewportSizeWidth, viewportSizeHeight),
                           textureCoordinate:vector_float2(1,0)),
            CBIImageVertex(position: vector_float2( viewportSizeWidth, -viewportSizeHeight),
                           textureCoordinate:vector_float2(0,1)),
            CBIImageVertex(position: vector_float2( viewportSizeWidth, viewportSizeHeight),
                           textureCoordinate:vector_float2(0,0))
        ]
        vertexBuffer = sharedContext.device.makeBuffer(bytes: textureVertices,
                                                        length: textureVertices.count * MemoryLayout<CBIImageVertex>.size,
                                                        options: MTLResourceOptions.storageModeShared)
    }
    func updateImage(img:UIImage){
        if let cgImage = img.cgImage {
            do{
                texture = try sharedContext.textureLoader.newTexture(cgImage:cgImage , options: [MTKTextureLoader.Option.SRGB : false])
            }catch{
                assert(false, "\(error)")
            }
        }else{
            assert(false, "cgImage is  nil")
        }
    }
}

