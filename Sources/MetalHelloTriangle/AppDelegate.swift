import Cocoa

let WIDTH  = 800
let HEIGHT = 600

class AppDelegate: NSObject, NSApplicationDelegate
{
    private var mWindow: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        let windowSize = NSSize(width: WIDTH, height: HEIGHT)
        let screenSize = NSScreen.main?.frame.size ?? .zero

        let rect = NSMakeRect((screenSize.width  - windowSize.width)  * 0.5,
                              (screenSize.height - windowSize.height) * 0.5,
                              windowSize.width,
                              windowSize.height)

        mWindow = NSWindow(contentRect: rect,
                           styleMask:   [.miniaturizable,
                                         .closable,
                                         .resizable,
                                         .titled],
                            backing:    .buffered,
                            defer:      false)

        mWindow?.title = "Hello Triangle"
        mWindow?.makeKeyAndOrderFront(nil)
    }
}
