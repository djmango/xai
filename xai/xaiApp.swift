//
//  xaiApp.swift
//  xai
//
//  Created by Sulaiman Ghori on 2/20/25.
//

import SwiftUI
import AppKit

// Custom window style
class CustomWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView], backing: backingStoreType, defer: flag)
        
        // Configure window appearance
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = true
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = true
        
        // Set the window level to floating (like NSPanel)
        self.level = .floating
        
        // Round the corners
        self.invalidateShadow()
    }
}

// Custom window scene style
struct CustomWindowStyle: WindowStyle {
    func makeWindow(windowScene: UIWindowScene) -> NSWindow {
        let window = CustomWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        return window
    }
}

@main
struct xaiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
                .background(.clear)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }
}
