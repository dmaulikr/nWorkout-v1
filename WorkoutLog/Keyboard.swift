//
//  Keyboard.swift
//  WorkoutLog
//
//  Created by Nathan Lanza on 8/14/16.
//  Copyright © 2016 Nathan Lanza. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
    func hideWasTapped()
    func backspaceWasTapped()
    func nextWasTapped()
}

class Keyboard: UIView {
    weak var delegate: KeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "Keyboard"
        let nib = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)
        
        let view = nib![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    @IBAction func keyTapped(_ sender: UIButton) {
        delegate?.keyWasTapped(character: sender.titleLabel!.text!)
    }
    @IBAction func hideTapped(_ sender: UIButton) {
        delegate?.hideWasTapped()
    }
    @IBAction func backspaceTapped(_ sender: UIButton) {
        delegate?.backspaceWasTapped()
    }
    @IBAction func nextTapped(_ sender: UIButton) {
        delegate?.nextWasTapped()
    }
    
}
