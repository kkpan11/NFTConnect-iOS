//
//  Coordinator.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set}
    var navigationController: BaseNavigationController { get set }
    
    func start()
}

extension Coordinator {
    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func start() {}
}

// MARK: - Controler to Coordinators delegate
protocol CommonControllerToCoordinatorDelegate: AnyObject {
    func commonControllerToCoordinator(eventType: AppFlowEventType)
}
