import MetalKit

let VERTEX_DATA: [SIMD3<Float>] =
[
    [ 0.0,  1.0, 0.0],
    [-1.0, -1.0, 0.0],
    [ 1.0, -1.0, 0.0]
]

let SHADERS_DIR_LOCAL_PATH        = "/Sources/Shaders"
let DEFAULT_SHADER_LIB_LOCAL_PATH = SHADERS_DIR_LOCAL_PATH + "/HelloTriangle.metallib"

class Renderer : NSObject
{
    public  var mView:         MTKView

    private let mPipeline:     MTLRenderPipelineState
    private let mCommandQueue: MTLCommandQueue

    public init(view: MTKView)
    {
        mView = view

        guard let cq = mView.device?.makeCommandQueue() else
        {
            fatalError("Could not create command queue")
        }
        mCommandQueue = cq

        let shaderLibPath = FileManager.default
                                       .currentDirectoryPath +
                            DEFAULT_SHADER_LIB_LOCAL_PATH

        guard let library = try! mView.device?.makeLibrary(filepath: shaderLibPath) else
        {
            fatalError("No shader library!")
        }
        let vertexFunction   = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")

        let vertDesc = MTLVertexDescriptor()
        vertDesc.attributes[0].format      = .float3
        vertDesc.attributes[0].bufferIndex = 0
        vertDesc.attributes[0].offset      = 0
        vertDesc.layouts[0].stride         = MemoryLayout<SIMD3<Float>>.stride

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = mView.colorPixelFormat
        pipelineDescriptor.vertexFunction                  = vertexFunction
        pipelineDescriptor.fragmentFunction                = fragmentFunction
        pipelineDescriptor.vertexDescriptor                = vertDesc

        guard let ps = try! mView.device?.makeRenderPipelineState(descriptor: pipelineDescriptor) else
        {
            fatalError("Couldn't create pipeline state")
        }
        mPipeline = ps

        super.init()
        mView.delegate = self
    }

    private func update()
    {
        let dataSize     = VERTEX_DATA.count * MemoryLayout.size(ofValue: VERTEX_DATA[0])
        let vertexBuffer = mView.device?.makeBuffer(bytes:   VERTEX_DATA,
                                                    length:  dataSize,
                                                    options: [])

        let commandBuffer  = mCommandQueue.makeCommandBuffer()!

        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: mView.currentRenderPassDescriptor!)
        //commandEncoder?.setViewport(self.viewport)
        commandEncoder?.setRenderPipelineState(mPipeline)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle,
                                       vertexStart: 0,
                                       vertexCount: 3,
                                       instanceCount: 1)
        commandEncoder?.endEncoding()

        commandBuffer.present(mView.currentDrawable!)
        commandBuffer.commit()
    }
}

extension Renderer: MTKViewDelegate
{
    public func draw(in view: MTKView)
    {
        // Called every frame
        self.update()
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        // This will be called on resize
    }
}
