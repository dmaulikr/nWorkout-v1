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
        createStacks()
        bindActions()
    }
    
    init() {
        super.init(frame: CGRect())
        createStacks()
        bindActions()
    }
    let buttonOne = UIButton()
    let buttonTwo = UIButton()
    let buttonThree = UIButton()
    let topSideButton = UIButton()
    let buttonFour = UIButton()
    let buttonFive = UIButton()
    let buttonSix = UIButton()
    let secondSideButton = UIButton()
    let buttonSeven = UIButton()
    let buttonEight = UIButton()
    let buttonNine = UIButton()
    let thirdSideButton = UIButton()
    let decimalButton = UIButton()
    let zeroButton = UIButton()
    let backspaceButton = UIButton()
    let nextButton = UIButton()
    
    func bindActions() {
        let numberButtons = [zeroButton,buttonOne,buttonTwo,buttonThree,buttonFour,buttonFive,buttonSix,buttonSeven,buttonEight,buttonNine,decimalButton]
        var characters = (0...9).map { "\($0)" }
        characters.append(".")
        
        for (number,button) in zip(characters, numberButtons) {
            button.setTitle(String(number), for: UIControlState())
            button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
        }
        
        backspaceButton.setImage(#imageLiteral(resourceName: "backspace"), for: UIControlState())
        backspaceButton.addTarget(self, action: #selector(backspaceTapped(_:)), for: .touchUpInside)
        
        
        nextButton.setTitle("Next", for: UIControlState())
        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
        
        
    }
    
    func createStacks() {
        let firstStackView = UIStackView(arrangedSubviews: [buttonOne,buttonTwo,buttonThree,topSideButton])
        let secondStackView = UIStackView(arrangedSubviews: [buttonFour,buttonFive,buttonSix,secondSideButton])
        let thirdStackView = UIStackView(arrangedSubviews: [buttonSeven,buttonEight,buttonNine,thirdSideButton])
        let fourthStackView = UIStackView(arrangedSubviews: [decimalButton,zeroButton,backspaceButton,nextButton])
        
        let stackViews = [firstStackView,secondStackView,thirdStackView,fourthStackView]
        
        for stackView in stackViews {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false
        }
        let masterStackView = UIStackView(arrangedSubviews: stackViews)
        masterStackView.axis = .vertical
        masterStackView.distribution = .fillEqually
        masterStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(masterStackView)
        
        let hideButton = UIButton()
        hideButton.setTitle("Hide", for: UIControlState())
        
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hideButton)
        hideButton.addTarget(self, action: #selector(hideTapped(_:)), for: .touchUpInside)
        
        
        hideButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        hideButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        hideButton.bottomAnchor.constraint(equalTo: masterStackView.topAnchor).isActive = true
        hideButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        masterStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        masterStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        masterStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
