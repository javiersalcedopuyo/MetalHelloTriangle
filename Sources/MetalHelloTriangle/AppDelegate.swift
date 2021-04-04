import Cocoa
import MetalKit

let WIDTH  = 800
let HEIGHT = 600

class ViewController : NSViewController
{
    override func loadView()
    {
        let rect = NSRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        view = NSView(frame: rect)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
    }
}

class AppDelegate: NSObject, NSApplicationDelegate
{
    private var mWindow:   NSWindow?
    private var mDevice:   MTLDevice?
    private var mRenderer: Renderer?

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        let screenSize = NSScreen.main?.frame.size ?? .zero

        let rect = NSMakeRect((screenSize.width  - CGFloat(WIDTH))  * 0.5,
                              (screenSize.height - CGFloat(HEIGHT)) * 0.5,
                              CGFloat(WIDTH),
                              CGFloat(HEIGHT))

        mWindow = NSWindow(contentRect: rect,
                           styleMask:   [.miniaturizable,
                                         .closable,
                                         .resizable,
                                         .titled],
                            backing:    .buffered,
                            defer:      false)

        mWindow?.title = "Hello Triangle"
        mWindow?.contentViewController = ViewController()
        mWindow?.makeKeyAndOrderFront(nil)

        mDevice = MTLCreateSystemDefaultDevice()
        if mDevice == nil { fatalError("NO GPU") }

        let view  = MTKView(frame: rect, device: mDevice)
        mRenderer = Renderer(view: view)

        mWindow?.contentViewController?.view = view
    }
}
