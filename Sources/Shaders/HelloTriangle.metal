#include <metal_stdlib>
using namespace metal;

struct VertexIn
{
    float3 position [[ attribute(0) ]];
    float3 color    [[ attribute(1) ]];
};

struct VertexOut
{
    float4 position [[ position ]];
    float3 color;
};

vertex
VertexOut vertex_main(VertexIn vert [[ stage_in ]])
{
    VertexOut out;
    out.position = float4(vert.position, 1.0f);
    out.color    = vert.color;

    return out;
}

fragment
float4 fragment_main(VertexOut frag [[ stage_in ]])
{
    return float4(sqrt(frag.color), 1.0);
}
