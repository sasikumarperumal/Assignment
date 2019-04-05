//
//  WarningBar.swift
//  Assginment
//
//  Created by ndot on 04/04/19.
//  Copyright © 2019 ndot. All rights reserved.
//

import UIKit

enum WarningBarAnimationLength {
    ///Shot animtion
    case shot
    ///Long animation
    case long
}

class WarningBar: NSObject {
    
    // settings snackbar
    var barHeight: CGFloat          = 50
    var backgroundColor: UIColor    = .black
    var textColor: UIColor          = .white
    var buttonColor: UIColor         = UIColor.black
    var buttonColorPressed: UIColor  = .gray
    var barLenght: WarningBarAnimationLength = .long
    
    //private variables
    // private let window          = UIApplication.shared.keyWindow!
    private let warningBarView  = UIView(frame: .zero)
    
    private let textLabel: UILabel      = UILabel()
    private let actionButton: UIButton  = UIButton()
    
    private var action: (() -> Void)? = nil
    
    override init(){
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: UIDevice.orientationDidChangeNotification, object: nil)

        
    }
    
    /// Show simple text notification
    open func show(message text: String) {
        
        setupWarningBarView()
        
        textLabel.text = text
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = textColor
        textLabel.frame = CGRect(x: (APP.window?.frame.width)! * 5/100, y: 0, width: (APP.window?.frame.width)! * 95/100, height: barHeight)
        warningBarView.addSubview(textLabel)
        
        show()
    }
    
    
    /// Show snackbar with text and button
    open func show(message text: String,withActionTitle actionTitle: String, action: @escaping () -> Void){
        self.action = action
        
        setupWarningBarView()
        
        textLabel.text = text
        textLabel.textColor = textColor
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.frame = CGRect(x: (APP.window?.frame.width)! * 5/100, y: 0, width: (APP.window?.frame.width)! * 75/100, height: barHeight)
        warningBarView.addSubview(textLabel)
        
        actionButton.setTitleColor(buttonColor,  for: .normal)
        actionButton.setTitleColor(.gray, for: .highlighted)
        actionButton.setTitle(actionTitle, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        actionButton.addTarget(self, action: #selector(actionButtonPress), for: .touchUpInside)
        actionButton.frame = CGRect(x: (APP.window?.frame.width)! * 73/100, y: 0, width: (APP.window?.frame.width)! * 25/100, height: barHeight)
        warningBarView.addSubview(actionButton)
        //Show
        show()
    }
    private func show(){
        switch barLenght {
        case .shot:
            animateBar(2)
        case .long:
            animateBar(3)
        }
    }
    
    private func setupWarningBarView(){
        APP.window?.addSubview(warningBarView)
        
        warningBarView.frame = CGRect(x: 0, y: (APP.window?.frame.height)!, width: (APP.window?.frame.width)!, height: barHeight)
        warningBarView.backgroundColor = self.backgroundColor
    }
    
    fileprivate func animateBar(_ timerLength: Float){
        
        UIView.animate(withDuration: 0.4, animations: {
            self.warningBarView.frame = CGRect(x: 0, y: (APP.window?.frame.height)! - self.barHeight, width: (APP.window?.frame.width)!, height: self.barHeight)
            
            Timer.scheduledTimer(timeInterval: TimeInterval(timerLength), target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
        })
    }
    
    // MARK: Selectors
    @objc private func actionButtonPress(){
        action!()
        hide()
    }
    
    @objc private func hide(){
        UIView.animate(withDuration: 0.4, animations: {
            self.warningBarView.frame = CGRect(x: 0, y: (APP.window?.frame.height)!, width: (APP.window?.frame.width)!, height: self.barHeight)
        })
    }
    
    @objc private func rotate(){
        self.warningBarView.frame = CGRect(x: 0, y: (APP.window?.frame.height)! - self.barHeight, width: (APP.window?.frame.width)!, height: self.barHeight)
        actionButton.frame = CGRect(x: (APP.window?.frame.width)! * 73/100, y: 0, width: (APP.window?.frame.width)! * 25/100, height: barHeight)
    }
}
