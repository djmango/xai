//
//  xaiApp.swift
//  xai
//
//  Created by Sulaiman Ghori on 2/20/25.
//

import SwiftUI
import AppKit

class InteractivePanel: NSPanel {
    override var canBecomeKey: Bool { true }
    
    override func cancelOperation(_: Any?) {
        WindowManager.shared.hideWindow()
    }
    
    override func flagsChanged(with event: NSEvent) {
        super.flagsChanged(with: event)
    }
}

class WindowManager {
    static let shared = WindowManager()
    
    public var window: InteractivePanel?
    private let animationDuration: TimeInterval = 0.2
    private let defaultSize = NSSize(width: 800, height: 600)
    
    /// Whether the window is visible
    public var windowIsVisible: Bool {
        guard let window else { return false }
        return window.isVisible && window.alphaValue > 0
    }
    
    func setupWindow() {
        let window = InteractivePanel(
            contentRect: NSRect(origin: .zero, size: defaultSize),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        // Configure window appearance
        window.level = .mainMenu
        window.isOpaque = false
        window.backgroundColor = .clear
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.hasShadow = true
        window.isMovableByWindowBackground = true
        
        // Set window behavior
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
        window.isFloatingPanel = true
        
        self.window = window
        centerWindow()
    }
    
    func showWindow() {
        guard let window = self.window else { return }
        window.alphaValue = 0
        centerWindow()
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animationDuration
            window.animator().alphaValue = 1
        })
    }
    
    func hideWindow() {
        guard let window = self.window else { return }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animationDuration
            window.animator().alphaValue = 0
        }, completionHandler: {
            window.orderOut(nil)
        })
    }
    
    func toggleWindow() {
        guard let window = self.window else { return }
        if window.alphaValue == 1 {
            hideWindow()
        } else {
            showWindow()
        }
    }
    
    private func centerWindow() {
        guard let window = self.window,
              let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        let windowFrame = window.frame
        
        let centerX = screenFrame.midX - windowFrame.width / 2
        let centerY = screenFrame.midY - windowFrame.height / 2
        
        let centeredFrame = NSRect(
            x: centerX,
            y: centerY,
            width: defaultSize.width,
            height: defaultSize.height
        )
        
        window.setFrame(centeredFrame, display: true, animate: true)
        window.makeKeyAndOrderFront(nil)
    }
}

@main
struct xaiApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { }  // Empty settings scene to prevent automatic window creation
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        WindowManager.shared.setupWindow()
        
        // Set the content view
        if let window = WindowManager.shared.window {
            window.contentView = NSHostingView(rootView: ContentView())
            WindowManager.shared.showWindow()
        }
        
        // Set up observers for window activation
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeKey),
            name: NSWindow.didBecomeKeyNotification,
            object: nil
        )
    }
    
    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows _: Bool) -> Bool {
        WindowManager.shared.showWindow()
        return false
    }
    
    @objc func windowDidBecomeKey(notification: Notification) {
        // Handle window activation if needed
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        false
    }
}
