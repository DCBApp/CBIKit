//
//  CBIKit.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import MetalKit

// 上下文
public let sharedContext = CBIKitContext()

public class CBIKitContext{
    
    public let device:MTLDevice//MTL设备
    public let commandQueue:MTLCommandQueue//MTL 队列
    public let defaultLibrary: MTLLibrary//MTL 标准库
    public let textureLoader: MTKTextureLoader//MTL 纹理加载器

    init() {
        /// device
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal Device")
        }
        self.device = device
        
        /// commandQueue
        guard let commandQueue = self.device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        self.commandQueue = commandQueue
        
        /// defaultLibrary
        do {
            let frameworkBundle = Bundle(for: CBIKitContext.self)
            let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
            self.defaultLibrary = try device.makeLibrary(filepath:metalLibraryPath)
        } catch {
            fatalError("Could not load library")
        }
        
        /// textureLoader
        self.textureLoader = MTKTextureLoader(device: self.device)

    }
}

