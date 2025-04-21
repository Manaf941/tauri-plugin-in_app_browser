import SwiftRs
import Tauri
import UIKit
import WebKit
import SafariServices

class OpenSafariArgs: Decodable {
    let url: String
    let entersReaderIfAvailable: Bool?
    let barCollapsingEnabled: Bool?
    let preferredControlTintColor: String?
    let preferredBarTintColor: String?
    let modalPresentationStyle: String?
    let modalTransitionStyle: String?
    let modalPresentationCapturesStatusBarAppearance: Bool?
}

class CloseSafariArgs: Decodable {
    let id: Int
}

class SafariDelegate: NSObject, SFSafariViewControllerDelegate {
    weak var plugin: InAppBrowserPlugin?
    let safariId: Int

    init(plugin: InAppBrowserPlugin, safariId: Int) {
        self.plugin = plugin
        self.safariId = safariId
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        plugin?.removeSafariController(for: safariId)
    }
}

class InAppBrowserPlugin: Plugin {
    private var safariControllers: [Int: (controller: SFSafariViewController, delegate: SafariDelegate)] = [:]
    private var safariIdCounter: Int = 0

    // Helper to remove controller from map
    func removeSafariController(for id: Int) {
        safariControllers[id] = nil
    }

    @objc public func open_safari(_ invoke: Invoke) throws {
        let args = try invoke.parseArgs(OpenSafariArgs.self)

        guard let url = URL(string: args.url) else {
            invoke.reject("Invalid URL")
            return
        }

        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = args.entersReaderIfAvailable ?? false
        configuration.barCollapsingEnabled = args.barCollapsingEnabled ?? false

        let safariViewController = SFSafariViewController(url: url, configuration: configuration)

        // preferredControlTintColor
        if let colorHex = args.preferredControlTintColor {
            if let color = UIColor(hex: colorHex) {
                safariViewController.preferredControlTintColor = color
            } else {
                invoke.reject("Unknown preferredControlTintColor: \(colorHex)")
                return
            }
        } else {
            safariViewController.preferredControlTintColor = .systemBlue
        }

        // preferredBarTintColor
        if let barColorHex = args.preferredBarTintColor {
            if let barColor = UIColor(hex: barColorHex) {
                safariViewController.preferredBarTintColor = barColor
            } else {
                invoke.reject("Unknown preferredBarTintColor: \(barColorHex)")
                return
            }
        }

        // modalPresentationStyle
        if let styleString = args.modalPresentationStyle {
            guard let style = UIModalPresentationStyleFromString(styleString) else {
                invoke.reject("Unknown modalPresentationStyle: \(styleString)")
                return
            }
            safariViewController.modalPresentationStyle = style
        } else {
            safariViewController.modalPresentationStyle = .automatic
        }

        // modalTransitionStyle
        if let transitionString = args.modalTransitionStyle {
            guard let transition = UIModalTransitionStyleFromString(transitionString) else {
                invoke.reject("Unknown modalTransitionStyle: \(transitionString)")
                return
            }
            safariViewController.modalTransitionStyle = transition
        } else {
            safariViewController.modalTransitionStyle = .coverVertical
        }

        // modalPresentationCapturesStatusBarAppearance
        if let captures = args.modalPresentationCapturesStatusBarAppearance {
            safariViewController.modalPresentationCapturesStatusBarAppearance = captures
        } else {
            safariViewController.modalPresentationCapturesStatusBarAppearance = true
        }

        // Assign delegate and store in map with id
        safariIdCounter += 1
        let safariId = safariIdCounter
        let delegate = SafariDelegate(plugin: self, safariId: safariId)
        safariViewController.delegate = delegate
        safariControllers[safariId] = (controller: safariViewController, delegate: delegate)

        DispatchQueue.main.async {
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                invoke.reject("No view controller found")
                return
            }

            viewController.present(safariViewController, animated: true, completion: nil)
            invoke.resolve(["id": safariId])
        }
    }

    @objc public func close_safari(_ invoke: Invoke) throws {
        let args = try invoke.parseArgs(CloseSafariArgs.self)
        guard let (controller, _) = safariControllers[args.id] else {
            invoke.reject("No SafariViewController found for id \(args.id)")
            return
        }
        DispatchQueue.main.async {
            controller.dismiss(animated: true) {
                self.removeSafariController(for: args.id)
                invoke.resolve([:])
            }
        }
    }
}

// Helper functions to convert string to enum values
func UIModalPresentationStyleFromString(_ string: String) -> UIModalPresentationStyle? {
    switch string {
    case "fullScreen": return .fullScreen
    case "pageSheet": return .pageSheet
    case "formSheet": return .formSheet
    case "currentContext": return .currentContext
    case "custom": return .custom
    case "overFullScreen": return .overFullScreen
    case "overCurrentContext": return .overCurrentContext
    case "popover": return .popover
    case "none": return .none
    case "automatic": return .automatic
    default: return nil
    }
}

func UIModalTransitionStyleFromString(_ string: String) -> UIModalTransitionStyle? {
    switch string {
    case "coverVertical": return .coverVertical
    case "flipHorizontal": return .flipHorizontal
    case "crossDissolve": return .crossDissolve
    case "partialCurl": return .partialCurl
    default: return nil
    }
}

@_cdecl("init_plugin_in_app_browser")
func initPlugin() -> Plugin {
    return InAppBrowserPlugin()
}

// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}