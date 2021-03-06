import Foundation
import UIKit

@objc(RNTypingdnarecorder)
class RNTypingdnarecorder: NSObject {
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    func initialize() {
        RNTypingDNARecorderMobile()
    }
    
    @objc
    func start() {
        RNTypingDNARecorderMobile.start()
    }
    
    @objc
    func stop() {
        RNTypingDNARecorderMobile.stop()
    }
    
    @objc
    func reset() {
        RNTypingDNARecorderMobile.reset()
    }
    
    @objc
    func pause() {
        RNTypingDNARecorderMobile.stop()
    }
    
    @objc
    func addTarget(_ targetId: String) {
        DispatchQueue.main.async {
            RNTypingDNARecorderMobile.addTarget(RNTypingdnarecorder.findUiTextField(targetId))
        }
    }
    
    @objc
    func removeTarget(_ targetId: String) {
        DispatchQueue.main.async {
            RNTypingDNARecorderMobile.removeTarget(RNTypingdnarecorder.findUiTextField(targetId))
        }
    }
    
    @objc
    func getTypingPattern(_ type: Int, length: Int, text: String, textId: Int, target: String, caseSensitive: Bool, callback: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            callback([RNTypingDNARecorderMobile.getTypingPattern(type, length, text, textId, RNTypingdnarecorder.findUiTextField(target), caseSensitive)])
        }
    }
    
    static private func findField(_ node: UIView?, _ target: String!) -> UIView? {
        
        if (node == nil) {
            return nil
        }
        
        if (node is UITextField) {
            let textField = node as! UITextField
            if (textField.placeholder == target) {
                return textField
            }
        }
        
        return node!.subviews.map{RNTypingdnarecorder.findField($0, target)}.filter{$0 != nil}.first ?? nil
    }
    
    static private func findUiTextField(_ targetId: String) -> UITextField! {
        let rootViewController = UIApplication.shared.topMostViewController()
        let view = rootViewController!.self.view!
        let targetField = RNTypingdnarecorder.findField(view, targetId) as! UITextField
        return targetField
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
