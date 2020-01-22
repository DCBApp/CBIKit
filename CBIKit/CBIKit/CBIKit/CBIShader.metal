//
//  CBIShader.metal
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

#include <metal_stdlib>
#include "CBIShaderTypes.h"
using namespace metal;

//MARK: 矩形着色器
//结构体 顶点着色器的返回值  片段着色器的输入值
struct RasterizerData{
    float4 position [[position]];//位置坐标 [[position]] 句柄 c++14
    float4 color;//颜色
};

/*
 顶点着色器: 有多少个顶点，顶点着色器就会执行多少次，区别在于传入的参数不同
 vertexID: 顶点索引值 0、1、2、3、4、5、6、7……
 vertices: 所有的顶点坐标信息，是一个数组，CBIVertexInputIndexVertices 是一个固定的索引值，约定好的，buffer是连续在一起的，通过这个索引值找到buffer，索引值与编码时的操作有关
 viewportSizePointer:视图端口大小，CBIVertexInputIndexViewportSize 是一个固定的索引值，约定好的，buffer是连续在一起的，通过这个索引值找到buffer，索引值与编码时的操作有关
 参数说明:
 vertexID:
 */
vertex RasterizerData vertexShader(uint vertexID [[vertex_id]],
                           constant CBIVertex*vertices [[buffer(CBIVertexInputIndexVertices)]],
                           constant vector_uint2 *viewportSizePointer [[buffer(CBIVertexInputIndexViewportSize)]])
{
    RasterizerData out;

    // 索引到位置数组中以获得当前顶点.
    // 位置以像素维数指定(即100的值是从原点开始的100个像素)。
    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    // 获取viewport大小并强制转换为float.
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    

    // 将像素空间中的位置转换为剪贴空间中的位置,
    // 将像素坐标除以视口大小的一半.
    // 实际上是在这里做的坐标归一化，很多是在外面做的坐标归一化，暂时写到这里是方便大家理解
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    // 将输入的颜色直接传递到光栅化器.
    out.color = vertices[vertexID].color;

    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // 返回插入的颜色.
    return in.color;
}

//MARK: 图片 着色器
struct ImageRasterizerData{
    float4 position [[position]];
    float2 textureCoordinate;
};

vertex ImageRasterizerData
imageVertexShader(uint vertexID [[vertex_id]],
                           constant CBIImageVertex*vertices [[buffer(CBIVertexInputIndexVertices)]],
                           constant vector_uint2 *viewportSizePointer [[buffer(CBIVertexInputIndexViewportSize)]])
{
    ImageRasterizerData out;

    // Index into the array of positions to get the current vertex.
    // The positions are specified in pixel dimensions (i.e. a value of 100
    // is 100 pixels from the origin).
    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    // Get the viewport size and cast to float.
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    

    // To convert from positions in pixel space to positions in clip-space,
    //  divide the pixel coordinates by half the size of the viewport.
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    // Pass the input color directly to the rasterizer.
    out.textureCoordinate = vertices[vertexID].textureCoordinate;

    return out;
}
fragment float4
imageFragmentShader(ImageRasterizerData in [[stage_in]],
                                    texture2d<half> colorTexture [[ texture(0) ]])
{
     constexpr sampler textureSampler (mag_filter::linear,
                                         min_filter::linear);

       // Sample the texture to obtain a color
       const half4 colorSample = colorTexture.sample(textureSampler, in.textureCoordinate);

       // return the color of the texture
       return float4(colorSample);
}
//MARK: s 着色器
