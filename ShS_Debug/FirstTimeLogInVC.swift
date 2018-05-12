//
//  FirstTimeLogInVC.swift
//  ShS_Debug
//
//  Created by Tschekalinskij, Alexander on 12.05.18.
//  Copyright © 2018 Tschekalinskij, Alexander. All rights reserved.
//

import UIKit
import Firebase

class FirstTimeLogInVC: UIViewController {

    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        joinButton.blink()
    }
    
    func setupButton()
    {
        joinButton.backgroundColor = .clear
        joinButton.layer.cornerRadius = 1
        joinButton.layer.borderWidth = 2
        joinButton.clipsToBounds = true
        joinButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        
        print("Join button pressed")
        
        let ref = Database.database().reference(fromURL: "https://shs-app-3f816.firebaseio.com/").child("users").childByAutoId()
        let userID = ref.key
        let timestamp = NSDate().timeIntervalSince1970
        let values = ["date" : timestamp]
        
        ref.updateChildValues(values)
        
        let defaults = UserDefaults.standard
        defaults.set(userID, forKey: "userID")
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.bounds.contains(point) ? self : nil
    }
    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
}
