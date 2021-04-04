import MetalKit

class Renderer : NSObject
{
    public var mView: MTKView

    public init(view: MTKView)
    {
        mView = view
        super.init()
        mView.delegate = self
    }

    private func update()
    {
        print("Hello frame!")
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
