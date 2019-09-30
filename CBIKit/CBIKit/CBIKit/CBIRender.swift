//
//  CBIRender.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import Foundation
import MetalKit


public class CBIRender:NSObject{
    
    private var _pipelineState:MTLRenderPipelineState?
    private var _vertexFunction:MTLFunction?
    private var _fragmentFunction:MTLFunction?
    var _vertexBuffer:MTLBuffer?
    var _texture:MTLTexture?
    var _viewportSize:vector_uint2 = .zero

    init(mtkView:MTKView) {
        super.init()
        _viewportSize.x = UInt32(mtkView.drawableSize.width)
        _viewportSize.y = UInt32(mtkView.drawableSize.height)
    }
    func configureShader(vertexShader:String,fragmentShader:String){
        _vertexFunction = sharedContext.defaultLibrary.makeFunction(name: vertexShader)
        _fragmentFunction = sharedContext.defaultLibrary.makeFunction(name: fragmentShader)
    }
    
    func configurePipelineState(mtkView:MTKView){
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "quinn.metal.render"
        pipelineStateDescriptor.vertexFunction = _vertexFunction
        pipelineStateDescriptor.fragmentFunction = _fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        do{
            _pipelineState = try sharedContext.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }catch{
            assert(false, "\(error)")
        }
    }
    
    deinit {
        print(#function)
    }
}
extension CBIRender:MTKViewDelegate{
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        _viewportSize.x = UInt32(size.width)
        _viewportSize.y = UInt32(size.height)
    }
    
    public func draw(in view: MTKView) {
        
        let commandBuffer = sharedContext.commandQueue.makeCommandBuffer()
        commandBuffer?.label = "CBIRenderImage"
        
        let renderPassDescriptor = view.currentRenderPassDescriptor
        
        if let _renderPassDescriptor = renderPassDescriptor, let currentDrawable = view.currentDrawable{
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: _renderPassDescriptor)
            
            renderEncoder?.setViewport(MTLViewport.init(originX: 0, originY: 0, width:Double(_viewportSize.x) , height: Double(_viewportSize.y), znear: 0.0, zfar: 1.0))
            renderEncoder?.setRenderPipelineState(_pipelineState!)
            renderEncoder?.setVertexBuffer(_vertexBuffer, offset: 0, index: 0)

            renderEncoder?.setVertexBytes(&_viewportSize,
                                          length: MemoryLayout<vector_uint2>.size,
                                          index: Int(CBIVertexInputIndexViewportSize.rawValue))
            if let texture = _texture{
                renderEncoder?.setFragmentTexture(texture, index: 0)
            }
            renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            renderEncoder?.endEncoding()
            commandBuffer?.present(currentDrawable)
            
        }
        commandBuffer?.commit()
    }
}
