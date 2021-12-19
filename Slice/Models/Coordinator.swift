//
//  Coordinator.swift
//  Slice
//

import Foundation
import UIKit

class Coordinator: NSObject {
    typealias Presentable = UIViewController
    private(set) weak var controller: UIViewController?
    
    init(root controller: UIViewController) {
        self.controller = controller
    }
    
    init(coordinator: Coordinator) {
        self.controller = coordinator.controller
    }
    
    func start(_ animated: Bool) {}
    
    func present(_ presentable: Presentable, animated: Bool, completion: (() -> Void)? = nil) {
        controller?.present(present(presentable), animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        controller?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - Private
    
    func present(_ presentable: Presentable) -> UIViewController {
        return presentable
    }
}
