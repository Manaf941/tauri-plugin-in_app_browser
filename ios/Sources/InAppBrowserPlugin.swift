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

class InAppBrowserPlugin: Plugin {
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
            if let color = UIColor(hexString: colorHex) {
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
            if let barColor = UIColor(hexString: barColorHex) {
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

        DispatchQueue.main.async {
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                invoke.reject("No view controller found")
                return
            }

            viewController.present(safariViewController, animated: true, completion: nil)
            invoke.resolve([:])
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
