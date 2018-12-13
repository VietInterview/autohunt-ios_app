///**
/**
Created by: Hiep Nguyen Nghia on 11/23/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class IntroController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        dataSource = self
        delegate = self
        // this sets the background color of the built-in paging dots
        view.backgroundColor = UIColor.darkGray
        
        // This is the starting point.  Start with step zero.
        setViewControllers([getStepZero()], direction: .forward, animated: false, completion: nil)
        
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [IntroController.self])
        appearance.pageIndicatorTintColor = .lightGray
        appearance.currentPageIndicatorTintColor = .black
        self.setupPageControl()
    }
    func getStepZero() -> IntroOneController {
        return storyboard!.instantiateViewController(withIdentifier: "IntroOneController") as! IntroOneController
    }
    
    func getStepOne() -> IntroTwoController {
        return storyboard!.instantiateViewController(withIdentifier: "IntroTwoController") as! IntroTwoController
    }
    
    func getStepTwo() -> IntroThreeController {
        return storyboard!.instantiateViewController(withIdentifier: "IntroThreeController") as! IntroThreeController
    }
    
    
    
}
// MARK: - UIPageViewControllerDataSource methods

extension IntroController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: IntroThreeController.self) {
            // 2 -> 1
            return getStepOne()
        } else if viewController.isKind(of: IntroTwoController.self) {
            // 1 -> 0
            return getStepZero()
        } else {
            // 0 -> end of the road
            return nil
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // Sets the status bar to hidden when the view has finished appearing
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
        UIApplication.shared.isStatusBarHidden = true
        statusBar.gone()
    }
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: IntroOneController.self) {
            // 0 -> 1
            return getStepOne()
        } else if viewController.isKind(of: IntroTwoController.self) {
            // 1 -> 2
            return getStepTwo()
        } else {
            // 2 -> end of the road
            return nil
        }
    }
    
    // Enables pagination dots
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    // This only gets called once, when setViewControllers is called
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

// MARK: - UIPageViewControllerDelegate methods

extension IntroController : UIPageViewControllerDelegate {
    
}
