//
//  LoadingOverlay.swift
//  HDHNews
//
//  Created by Hiep Nguyen Nghia on 3/27/18.
//  Copyright © 2018 Hiep Nguyen Nghia. All rights reserved.
//

import Foundation
import UIKit
public class LoadingOverlay{
    
    var overlayView : UIView!
    var mView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        self.overlayView = UIView()
        self.mView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        
        overlayView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100))
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        
        mView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        mView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        mView.clipsToBounds = true
        mView.layer.cornerRadius = 0
        mView.layer.zPosition = 1
        
        activityIndicator.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100))
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2,y: overlayView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        overlayView.addSubview(activityIndicator)
        mView.addSubview(overlayView)
    }
    
    public func showOverlay(view: UIView) {
        overlayView.center = view.center
        mView.center = view.center
        view.addSubview(mView)
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        mView.removeFromSuperview()
    }
}
