//
//  ViewController.swift
//  IOS_HW_2
//
//  Created by Андрей Гусев on 11/10/2022.
//

import UIKit

extension CALayer{
    public func applyShadow() {
        self.shadowColor = UIColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.25
        ).cgColor
        self.shadowOffset = CGSize(
            width: 0,
            height: 2.0
        )
        self.shadowOpacity = 1.0
        self.shadowRadius = 0
    }
}

final class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCommentView()
        // Do any additional setup after loading the view.
    }
    
    private let commentLabel = UILabel()
    private let valueLabel = UILabel()
    private var value = 0
    
    private let incrementButton = UIButton()
    
    let colorPaletteView = ColorPaletteView()
    
    private func setupView() {
        view.backgroundColor = .systemGray6
        setupIncrementButton()
        setupValueLabel()
        
        colorPaletteView.isHidden = true;
        setupMenuButtons()
        setupColorControlSV()
    }
    
    private func updateUI() {
        setupValueLabel()
        updateCommentLabel(value: self.value)
        setupCommentView()
    }
    
    private func setupIncrementButton() {
        incrementButton.setTitle("Increment", for: .normal)
        incrementButton.setTitleColor(.black, for: .normal)
        incrementButton.layer.cornerRadius = 12
        incrementButton.titleLabel?.font = .systemFont(
            ofSize: 16.0,
            weight: .medium
        )
        incrementButton.backgroundColor = .white
        incrementButton.layer.applyShadow()
        self.view.addSubview(incrementButton)
        incrementButton.setHeight(48)
        incrementButton.pinTop(to: self.view.centerYAnchor )
        incrementButton.pin(to: self.view, [.left : 24, .right : 24])
        incrementButton.addTarget(
            self,
            action: #selector(incrementButtonPressed),
            for: .touchUpInside
        )
    }
    
    private func changeSetupValueLabelColor(){
        let tmp = colorPaletteView.chosenColor
        if (tmp.redComponent < UIColor.systemGray.redComponent
            && tmp.blueComponent < UIColor.systemGray.blueComponent
            && tmp.greenComponent < UIColor.systemGray.greenComponent
        ) {
            self.valueLabel.textColor = .white
        } else {
            self.valueLabel.textColor = .black
        }
    }
    
    private func setupValueLabel() {
        valueLabel.font = .systemFont(
            ofSize: 40.0,
            weight: .bold
        )
        changeSetupValueLabelColor()
        valueLabel.text = "\(value)"
        
        self.view.addSubview(valueLabel)
        valueLabel.pinBottom(to: incrementButton, 16)
        valueLabel.pinCenterX(to: self.view)
        valueLabel.pinCenterY(to: self.view, -100)
    }
    
    //123
    @objc
    private func incrementButtonPressed() {
        value += 1
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        UIView.animate(withDuration: 1) {
            self.updateUI()
        }
    }
    
    @discardableResult
    private func setupCommentView() -> UIView {
        let commentView = UIView()
        commentView.backgroundColor = .white
        commentView.layer.cornerRadius = 12
        view.addSubview(commentView)
        commentView.pinTop(to:
                self.view.safeAreaLayoutGuide.topAnchor)
        commentView.pin(to: self.view, [.left: 24, .right: 24])
        commentLabel.font = .systemFont(
            ofSize: 14.0,
            weight: .regular
        )
        commentLabel.textColor = .systemGray
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .center
        commentView.addSubview(commentLabel)
        commentLabel.pin(
            to: commentView,
            [
                .top: 16,
                .left: 16,
                .bottom: 16,
                .right: 16
            ]
        )
        return commentView
    }
    
    func updateCommentLabel(value: Int) {
        switch value {
        case 0...10:
            commentLabel.text = "1"
        case 10...20:
            commentLabel.text = "2"
        case 20...30:
            commentLabel.text = "3"
        case 30...40:
            commentLabel.text = "4"
        case 40...50:
            commentLabel.text = "! ! ! ! ! ! ! ! ! "
        case 50...60:
            commentLabel.text = "big boy"
        case 60...70:
            commentLabel.text = "70 70 70 moreeeee"
        case 70...80:
            commentLabel.text = "⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ "
        case 80...90:
            commentLabel.text = "80+\n go higher!"
        case 90...100:
            commentLabel.text = "100!! to the moon!!"
        default:
            break
        }
    }
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(
            ofSize: 16.0,
            weight: .medium
        )
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalTo:
                                        button.widthAnchor).isActive = true
        return button
    }
    
    let buttonsSV = UIStackView()
    
    private func setupMenuButtons() {
        let colorsButton = makeMenuButton(title: "🎨")
        colorsButton.addTarget(self, action: #selector(paletteButtonPressed), for: .touchUpInside)
        
        let notesButton = makeMenuButton(title: "📝")
        let newsButton = makeMenuButton(title: "📰")
//        buttonsSV = UIStackView(arrangedSubviews:
//                                        [colorsButton, notesButton, newsButton])
        buttonsSV.addArrangedSubview(colorsButton)
        buttonsSV.addArrangedSubview(notesButton)
        buttonsSV.addArrangedSubview(newsButton)
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually
        self.view.addSubview(buttonsSV)
        buttonsSV.pin(to: self.view, [.left: 24, .right: 24])
        buttonsSV.pinBottom(to: self.view, 24)
    }
    
    private func setupColorControlSV() {
        print("инициализация штуки")
        colorPaletteView.addTarget(self, action: #selector(changeColor), for: .touchDragInside)
        colorPaletteView.translatesAutoresizingMaskIntoConstraints = false
        colorPaletteView.isHidden = true
        view.addSubview(colorPaletteView)
        
//        colorPaletteView.pinTop(to: incrementButton, 8)
//        colorPaletteView.pinRight(to: view.safeAreaLayoutGuide.leadingAnchor, 24)
//        colorPaletteView.pinLeft(to: view.safeAreaLayoutGuide.trailingAnchor, -24)
//        colorPaletteView.pinBottom(to: buttonsSV, -8)
        NSLayoutConstraint.activate([
            colorPaletteView.topAnchor.constraint(
                equalTo: incrementButton.bottomAnchor,
                constant: 8
            ),
            colorPaletteView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),
            colorPaletteView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            colorPaletteView.bottomAnchor.constraint(
                equalTo: buttonsSV.topAnchor,
                constant: -8
            )
        ])
    }
    
    @objc
    private func paletteButtonPressed() {
        colorPaletteView.isHidden = !colorPaletteView.isHidden
        print("я жмал на кнопку")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @objc
    private func changeColor(_ slider: ColorPaletteView) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = slider.chosenColor
            self.changeSetupValueLabelColor()
        }
    }
    
    
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

