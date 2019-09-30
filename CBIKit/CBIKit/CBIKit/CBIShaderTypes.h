//
//  CBIShaderTypes.h
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

#ifndef CBIShaderTypes_h
#define CBIShaderTypes_h
#include <simd/simd.h>

typedef enum CBIVertexInputIndex
{
    CBIVertexInputIndexVertices     = 0,
    CBIVertexInputIndexViewportSize = 1,
} CBIVertexInputIndex;
typedef struct
{
    vector_float2 position;
    vector_float4 color;
} CBIVertex;

typedef struct
{
    vector_float2 position;
    vector_float2 textureCoordinate;
} CBIImageVertex;
#endif /* CBIShaderTypes_h */
