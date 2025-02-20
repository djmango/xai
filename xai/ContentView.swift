//
//  ContentView.swift
//  xai
//
//  Created by Sulaiman Ghori on 2/20/25.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        print("Creating WebView for URL: \(url)")
        
        // Create configuration
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        
        // Create web view with configuration
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.wantsLayer = true
        webView.layer?.cornerRadius = 8
        webView.layer?.masksToBounds = true
        
        // Load the URL
        let request = URLRequest(url: url)
        print("Loading request: \(request)")
        webView.load(request)
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Handle updates if needed
    }
    
    // Add coordinator for handling navigation events
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
            print("Coordinator initialized")
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Started loading...")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Failed to load: \(error.localizedDescription)")
            print("Error details: \(error)")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading!")
            print("Current URL: \(webView.url?.absoluteString ?? "none")")
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        return visualEffectView
    }
    
    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

struct CustomTitleBar: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            CustomTitleBar(title: "Grok")
            
            ZStack {
                // Apply a macOS visual effect layer with modern blur
                VisualEffectView(material: colorScheme == .dark ? .hudWindow : .fullScreenUI, blendingMode: .behindWindow)
                    .edgesIgnoringSafeArea(.all)
                
                // Embed the web content
                WebView(url: URL(string: "https://grok.com")!)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
                    .padding([.horizontal, .bottom], 1) // Subtle border effect
            }
        }
        .background(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            print("ContentView appeared")
            setupWindowAppearance()
        }
    }
    
    private func setupWindowAppearance() {
        if let window = NSApplication.shared.windows.first {
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.isOpaque = false
            window.backgroundColor = .clear
            window.isMovableByWindowBackground = true
            
            // Set window level to floating (like NSPanel)
            window.level = .floating
            
            // Enable vibrancy
            window.hasShadow = true
        }
    }
}

#Preview {
    ContentView()
}
