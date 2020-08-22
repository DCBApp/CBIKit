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
    
    private var pipelineState:MTLRenderPipelineState?//渲染管线状态
    private var vertexFunction:MTLFunction?//顶点着色器程序
    private var fragmentFunction:MTLFunction?//片段着色器程序
    var vertexBuffer:MTLBuffer?//顶点坐标buffer
    var texture:MTLTexture? //纹理
    var viewportSize:vector_uint2 = .zero //视口大小，即展示的区域的大小
    var commandBufferLabel:String = "Quinnn.CBIKit.CBIRender.CommandBuffer" //commandBuffer 标识符
    var pipelineLabel:String = "Quinnn.CBIKit.CBIRender.Pipline" //commandBuffer 标识符
    
    init(mtkView:MTKView) {
        super.init()
        viewportSize.x = UInt32(mtkView.drawableSize.width)
        viewportSize.y = UInt32(mtkView.drawableSize.height)
    }
    func configureShader(vertexShader:String,fragmentShader:String){
        vertexFunction = sharedContext.defaultLibrary.makeFunction(name: vertexShader)
        fragmentFunction = sharedContext.defaultLibrary.makeFunction(name: fragmentShader)
    }
    
    func configurePipelineState(mtkView:MTKView){
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = pipelineLabel
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        do{
            pipelineState = try sharedContext.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
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
        viewportSize.x = UInt32(size.width)
        viewportSize.y = UInt32(size.height)
    }
    
    public func draw(in view: MTKView) {
        
        let commandBuffer = sharedContext.commandQueue.makeCommandBuffer()
        commandBuffer?.label = commandBufferLabel
        
        let renderPassDescriptor = view.currentRenderPassDescriptor
        
        if let _renderPassDescriptor = renderPassDescriptor, let currentDrawable = view.currentDrawable{
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: _renderPassDescriptor)
            
            renderEncoder?.setViewport(MTLViewport.init(originX: 0, originY: 0, width:Double(viewportSize.x) , height: Double(viewportSize.y), znear: 0.0, zfar: 1.0))
            renderEncoder?.setRenderPipelineState(pipelineState!)
            renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            //视口大小设置，vertexshader 中的 视口数据设置再此
            renderEncoder?.setVertexBytes(&viewportSize,
                                          length: MemoryLayout<vector_uint2>.size,
                                          index: Int(CBIVertexInputIndexViewportSize.rawValue))
            if let texture = texture{
                renderEncoder?.setFragmentTexture(texture, index: 0)
            }
            renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            renderEncoder?.endEncoding()
            commandBuffer?.present(currentDrawable)
            
        }
        commandBuffer?.commit()
    }
}
