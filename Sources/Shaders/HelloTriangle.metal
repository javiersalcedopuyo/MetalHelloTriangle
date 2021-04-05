#include <metal_stdlib>
using namespace metal;

struct VertexIn
{
    float3 position [[ attribute(0) ]];
};

vertex
float4 vertex_main(VertexIn vert [[ stage_in ]])
{
    return float4(vert.position, 1.0f);
}

fragment
float4 fragment_main()
{
    return float4(1,0,0,1);
}
