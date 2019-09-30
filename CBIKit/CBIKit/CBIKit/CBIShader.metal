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

struct RasterizerData{
    float4 position [[position]];
    float4 color;
};


vertex RasterizerData vertexShader(uint vertexID [[vertex_id]],
                           constant CBIVertex*vertices [[buffer(CBIVertexInputIndexVertices)]],
                           constant vector_uint2 *viewportSizePointer [[buffer(CBIVertexInputIndexViewportSize)]])
{
    RasterizerData out;

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
    out.color = vertices[vertexID].color;

    return out;
}




fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // Return the interpolated color.
    return in.color;
}


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
