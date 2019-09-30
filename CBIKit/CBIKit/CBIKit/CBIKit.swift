//
//  CBIKit.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import MetalKit


public let sharedContext = CBIKitContext()

public class CBIKitContext{
    
    public let device:MTLDevice
    public let commandQueue:MTLCommandQueue
    public let defaultLibrary: MTLLibrary
    public let textureLoader: MTKTextureLoader

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

