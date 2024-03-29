//
//  WZRoute.swift
//  WZRoute
//
//  Created by xiaobin liu on 2019/7/29.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import UIKit

/// MARK - 路由
@objc public class WZRoute: NSObject {
    
    /// 完成类型别名
    public typealias Completion = (() -> Swift.Void)?
    
    /// push
    ///
    /// - Parameters:
    ///   - viewController: 需要跳转的控制器
    ///   - animated: 是否动画(默认: true)
    ///   - completion: 动画完成回掉(默认: nil)
    @objc open class func push(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = navigationController() else {
            return
        }
        viewController.hidesBottomBarWhenPushed = true
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.pushViewController(viewController, animated: animated)
        CATransaction.commit()
        
    }
    
    
    /// pop
    ///
    /// - Parameters:
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    @objc open class func pop(_ animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = navigationController() else {
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.popViewController(animated: animated)
        CATransaction.commit()
    }
    

    /// popRoot
    ///
    /// - Parameters:
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    @objc open class func popRoot(_ animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = navigationController() else {
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    
    /// present
    ///
    /// - Parameters:
    ///   - viewController: 需要跳转的控制器
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    @objc open class func present(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        
        guard let fromViewController = UIViewController.topMost else { return  }
        DispatchQueue.main.async {
          fromViewController.present(viewController, animated: animated, completion: completion)
        }
    }
    
    
    /// dismiss
    ///
    /// - Parameters:
    ///   - animated: 是否动画(默认: true)
    ///   - completion: completion(默认: nil)
    @objc open class func dismiss(animated: Bool = true, completion: Completion = nil) {
        
        guard let fromViewController = UIViewController.topMost else { return  }
        fromViewController.view.endEditing(true)
        fromViewController.dismiss(animated: animated, completion: completion)
    }
    
    
    /// showDetail
    ///
    /// - Parameters:
    ///   - viewController: viewController description
    ///   - sender: sender description
    ///   - completion: Completion
    @objc open class func showDetail(_ viewController: UIViewController, sender: Any?, completion: Completion = nil) {
        
        guard let fromViewController = UIViewController.topMost else { return  }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        fromViewController.showDetailViewController(viewController, sender: sender)
        CATransaction.commit()
    }
    
    
    /// setViewControllers
    ///
    /// - Parameters:
    ///   - viewControllers: viewControllers description
    ///   - animated: animated description
    ///   - completion: Completion
    @objc open class func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = true, completion: Completion = nil) {
        
        guard let navigationController = navigationController() else {
            return
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.setViewControllers(viewControllers, animated: animated)
        CATransaction.commit()
    }
    
    /// setRootViewController
    ///
    /// - Parameters:
    ///   - rootViewController: viewControllers description
    ///   - duration: duration
    @objc open class func setRootViewController(_ rootViewController: UIViewController, duration: CGFloat = 0.5) {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        UIView.transition(with: window, duration: duration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.subviews.forEach { $0.removeFromSuperview() }
            window.rootViewController = nil
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            UIView.setAnimationsEnabled(oldState)
        }, completion: nil)
    }
    
    
    /// 获取Window上面的根控制器
    ///
    /// - Returns: return value description
    @objc open class func rootViewController() -> UIViewController {
        return UIApplication.shared.windows.first(where: {$0.isKeyWindow})!.rootViewController!
    }
    
    /// 返回当前树的导航栏
    @objc open class func navigationController() -> UINavigationController? {
        
        if let navi = UIViewController.topMost?.navigationController {
            return navi
        }
        
        if let navi = UIViewController.topMost?.presentingViewController?.navigationController {
            return navi
        }
        
        if let navi = UIViewController.topMost?.presentingViewController as? UINavigationController {
            return navi
        }
        
        if let tabbar = UIViewController.topMost?.presentingViewController as? UITabBarController,
           let navi = tabbar.selectedViewController as? UINavigationController {
            return navi
        }
        
        return nil
    }
    
    
    /// 跳转新控制器移除上个控制器
    /// - Parameters:
    ///   - viewController: viewControllers description
    ///   - animated: animated description
    ///   - completion: Completion
    @objc open class func setViewControllerRemoveLast(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        guard let navigationController = navigationController() else {
            return
        }
        var temArray: [UIViewController] = navigationController.viewControllers.dropLast()
        temArray.append(viewController)
        setViewControllers(temArray, animated: animated, completion: completion)
    }
    
    /// 跳转新当前控制器，移除历史栈
    /// - Parameters:
    ///   - viewController: viewControllers description
    ///   - animated: animated description
    ///   - completion: Completion
    @objc open class func setViewControllerRemoveCurrent(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {
        guard let navigationController = navigationController() else {
            return
        }
        var temArray: [UIViewController] = []
        for vc in navigationController.viewControllers {
            if vc.classForCoder != viewController.classForCoder {
                temArray.append(vc)
            }
        }
        temArray.append(viewController)
        setViewControllers(temArray, animated: animated, completion: completion)
    }
    
    /// 移除某个控制器
    /// - Parameters:
    ///   - viewController: viewController description
    ///   - animated: animated description
    ///   - completion: completion description
    @objc open class func popController(_ viewController: UIViewController, animated: Bool = true, completion: Completion = nil) {

        guard let navigationController = viewController.navigationController, let topViewController = UIViewController.topMost else {
            return
        }
        var temArray: [UIViewController] = []
        temArray.append(contentsOf: navigationController.viewControllers)
        temArray.removeAll(where: {$0.classForCoder == viewController.classForCoder})
        
        var isAnimated = animated
        if navigationController.viewControllers.last?.classForCoder == viewController.classForCoder && (viewController.presentedViewController == topViewController || viewController.presentedViewController == nil) {
            
        }else{
            isAnimated = false
        }
        
        viewController.presentedViewController?.dismiss(animated: false, completion: nil)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController.setViewControllers(temArray, animated: isAnimated)
        CATransaction.commit()
    }
}


// MARK: - Methods
@objc public extension UIViewController {
    
    /// sharedApplication
    private class var sharedApplication: UIApplication? {
        let selector = NSSelectorFromString("sharedApplication")
        return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }
    
    
    /// 返回当前应用程序的最顶层视图控制器。
    @objc class var topMost: UIViewController? {
        
        if #available(iOS 13.0, *) {
            let rootViewController = WZRoute.rootViewController()
            return self.topMost(of: rootViewController)
        } else {
            guard let currentWindows = self.sharedApplication?.windows else { return nil }
            var rootViewController: UIViewController?
            for window in currentWindows {
                if let windowRootViewController = window.rootViewController {
                    rootViewController = windowRootViewController
                    break
                }
            }
            
            return self.topMost(of: rootViewController)
        }
    }
    
    
    /// 返回给定视图控制器堆栈中最顶层的视图控制器
    ///
    /// - Parameter viewController: viewController description
    /// - Returns: return value description
    @objc class func topMost(of viewController: UIViewController?) -> UIViewController? {
        
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        return viewController
    }
}
