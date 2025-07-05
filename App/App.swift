//
//  App.swift
//  NotchNotification
//
//  Created by 秋星桥 on 2024/9/19.
//  Enhanced by kingkwahli on 2025/6/26.
//
import NotchNotification
import SwiftUI

@main
struct NotchNotificationDemoApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            panel
                .frame(
                    minWidth: 1000, idealWidth: 1000, maxWidth: 1200,
                    minHeight: 340, idealHeight: 340, maxHeight: 440,
                    alignment: .center
                )
                .background(.ultraThinMaterial)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
    @State private var showAboutPopover = false
    @State private var showSymbolHelpPopover = false
    @State private var showTextHelpPopover = false
    @State var message: String = ""
    @State var sfsymbol: String = ""
    @State var textStatus = true
    @State var interval: TimeInterval = 3 {
        didSet { if interval < 0 { interval = 0 } }
    }
    
    var panel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notch Notification Demo Application")
                    .font(.title)
                    .bold()
                Button(action: {
                    showAboutPopover.toggle()
                }) {
                    Image(systemName: "questionmark.circle")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showAboutPopover, arrowEdge: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Notch Notification")
                            .font(.headline)
                        Text("Integrate your app's notifications into the MacBook notch")
                            .font(.subheadline)
                        Link("Learn more", destination: URL(string: "https://github.com/kingkwahli/NotchNotification")!)                                }
                    .padding()
                    .frame(width: 250)
                }
            }
            Text("Designed by Lakr233 • Enhanced by kingkwahli")
                .font(.caption)
                .bold()
            TextField("Notification Text (e.g. Hello World!)", text: $message)
                .frame(minWidth: 300)
            HStack {
                TextField("SF Symbol Name (e.g. circle.fill)", text: $sfsymbol)
                    .frame(minWidth: 300)
                Button(action: {
                    showSymbolHelpPopover.toggle()
                }) {
                    Image(systemName: "questionmark.circle")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showSymbolHelpPopover, arrowEdge: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SF Symbol Help")
                            .font(.headline)
                        Text("Custom symbols only works on Message, Custom, and Icon Only modes")
                            .font(.subheadline)                              }
                    .padding()
                    .frame(width: 250)
                }
                Button("Open SF Symbols") {
                    openSFSymbolsApp()
                }
            }
            HStack {
                Toggle("Enable Text Area (below notch)", isOn: $textStatus)
                    .toggleStyle(.checkbox)
                Button(action: {
                    showTextHelpPopover.toggle()
                }) {
                    Image(systemName: "questionmark.circle")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showTextHelpPopover, arrowEdge: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Text Area Help")
                            .font(.headline)
                        Text("Text Area enabling & disabling only works on Message mode")
                        .font(.subheadline)                              }
                    .padding()
                    .frame(width: 250)
                }
            }
            HStack {
                Group {
                    if interval <= 0 {
                        Text("0 seconds")
                    } else {
                        Text("\(Int(interval)) seconds")
                    }
                }
                .frame(width:72, alignment: .leading)
                Button("-") { interval -= 1 }
                    .disabled(interval <= 0)
                Button("+") { interval += 1 }
                    .disabled(interval >= 99)
                Spacer()
                Button("Custom") {
                    NotchNotification.present(custom: message, interval: interval, sfsymbol: sfsymbol)
                }
                Button("Error") {
                    NotchNotification.present(error: message, interval: interval)
                }
                Button("Success") {
                    NotchNotification.present(success: message, interval: interval)
                }
                Button("Loading") {
                    NotchNotification.present(loading: message, interval: interval)
                }
                Button("Downloading") {
                    NotchNotification.present(download: message, interval: interval)
                }
                Button("Message") {
                    NotchNotification.present(
                        trailingView: Image(systemName: sfsymbol).foregroundStyle(.black),
                        bodyView: textStatus
                        ? AnyView(HStack {
                            Text(message)
                        })
                        : AnyView(EmptyView().frame(width: 0, height: 0)),                        interval: interval
                    )
                }
                Button("Camera") {
                    NotchNotification.present(camera: message, interval: interval)
                }
                Button("Microphone") {
                    NotchNotification.present(microphone: message, interval: interval)
                }
                Button("Icon Only") {
                    NotchNotification.present(icon: message, interval: interval, sfsymbol: sfsymbol
                    )
                }
            }
        }
        .padding(32)
    }
}
    func openSFSymbolsApp() {
        let regularBundleID = "com.apple.SFSymbols"
        let betaBundleID = "com.apple.SFSymbols-Beta"
        let downloadURL = URL(string: "https://developer.apple.com/sf-symbols/")!

        if let regularAppURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: regularBundleID) {
            NSWorkspace.shared.open(regularAppURL)
            return
        }

        if let betaAppURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: betaBundleID) {
            NSWorkspace.shared.open(betaAppURL)
            return
        }

        NSWorkspace.shared.open(downloadURL)
    }

