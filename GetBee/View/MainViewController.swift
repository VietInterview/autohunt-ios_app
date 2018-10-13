//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//
import LGSideMenuController

class MainViewController: LGSideMenuController {

    private var type: UInt?
    
    func setup(type: UInt) {
        self.type = type

        // -----

        if (self.storyboard != nil) {
            // Left and Right view controllers is set in storyboard
            // Use custom segues with class "LGSideMenuSegue" and identifiers "left" and "right"

            // Sizes and styles is set in storybord
            // You can also find there all other properties

            // LGSideMenuController fully customizable from storyboard
        }
        else {
            leftViewController = LeftViewController()

            leftViewWidth = 250.0;
            leftViewBackgroundImage = UIImage(named: "imageLeft")
            leftViewBackgroundColor = UIColor(red: 0.5, green: 0.65, blue: 0.5, alpha: 0.95)
            rootViewCoverColorForLeftView = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)
        }

        // -----

        let greenCoverColor = UIColor(red: 0.0, green: 0.1, blue: 0.0, alpha: 0.3)
        let purpleCoverColor = UIColor(red: 0.1, green: 0.0, blue: 0.1, alpha: 0.3)
        let regularStyle: UIBlurEffectStyle

        if #available(iOS 10.0, *) {
            regularStyle = .regular
        }
        else {
            regularStyle = .light
        }

        // -----

        switch type {
        case 2:
            leftViewPresentationStyle = .slideBelow

            break
       
        default:
            break
        }
    }

    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)

        if !isLeftViewStatusBarHidden {
            leftView?.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
    }
    

    override var isLeftViewStatusBarHidden: Bool {
        get {
            if (type == 8) {
                return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == .phone
            }

            return super.isLeftViewStatusBarHidden
        }

        set {
            super.isLeftViewStatusBarHidden = newValue
        }
    }

    deinit {
        print("MainViewController deinitialized")
    }

}
