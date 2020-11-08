//
//  AlertView.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/8/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

protocol AlertViewDelegate : class {
    func alertView(_ alertView : AlertView , didAdd alertInfo : Dictionary<String,Any>)
}

class AlertView : UIView , Themed , UITextViewDelegate{
    
    let titleAlertKey : String = "titleAlertKey"
    let descriptionAlertKey : String = "descriptionAlertKey"
    
    weak var delegate : AlertViewDelegate?
    
    var containerViewHeightConstraint : NSLayoutConstraint?
    var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    var topTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize + 3)
        label.textAlignment = .center
        return label
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        return label
    }()
    
    var titleTextField : UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        textField.layer.borderWidth = 0.5
        textField.autocorrectionType = .no
        return textField
    }()
    
    var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        return label
    }()
    
    var maximumDecriptionTextViewHeight : CGFloat = 120
    var descriptionTextViewHeightConstraint : NSLayoutConstraint?
    var descriptionTextView : UITextView = {
        let textView = UITextView()
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 0.5
        textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        textView.backgroundColor = .clear
        textView.autocorrectionType = .no
        return textView
    }()
    
    var addButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.layer.borderWidth = 0.5
        return button
    }()
    
    var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.layer.borderWidth = 0.5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        setupTheme()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func setupViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.addSubview(containerView)
        
        self.cancelButton.addTarget(self, action: #selector(didCancel), for: .touchUpInside)
        self.addButton.addTarget(self, action: #selector(didAdd), for: .touchUpInside)
        
        
        descriptionTextView.delegate = self
        
        // containerView constraints
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        let screenBounds = UIScreen.main.bounds
        let containerWidth = screenBounds.width < screenBounds.height ? screenBounds.width*0.8 : screenBounds.height*0.8
        containerView.widthAnchor.constraint(equalToConstant: containerWidth).isActive = true
        self.containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerViewPerfectHeight())
        containerViewHeightConstraint?.isActive = true
        
        // add views to container view
        self.containerView.addSubview(topTitleLabel)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(titleTextField)
        self.containerView.addSubview(descriptionLabel)
        self.containerView.addSubview(descriptionTextView)
        
        self.containerView.addSubview(cancelButton)
        self.containerView.addSubview(addButton)
        
        // constraint container subviews
        
        topTitleLabel.setConstraints(containerView.leadingAnchor, 10, containerView.topAnchor, 10 , containerView.trailingAnchor , -10)
        
        titleLabel.setConstraints(containerView.leadingAnchor, 10, topTitleLabel.bottomAnchor, 20)
        let textFieldHeight = "".size(withMaximumWidth: containerView.frame.width-20, font: titleTextField.font!).height + 10
        titleTextField.setConstraints(containerView.leadingAnchor, 10, titleLabel.bottomAnchor, 5, containerView.trailingAnchor , -10 , nil , textFieldHeight)

        
        descriptionLabel.setConstraints(containerView.leadingAnchor, 10, titleTextField.bottomAnchor, 10)
        descriptionTextView.setConstraints(containerView.leadingAnchor, 10, descriptionLabel.bottomAnchor, 5 , containerView.trailingAnchor , -10 )
        
        let textViewHeight = descriptionTextView.text.size(withMaximumWidth: containerView.frame.width-30, font: descriptionTextView.font!).height + 10
        descriptionTextViewHeightConstraint = descriptionTextView.heightAnchor.constraint(equalToConstant: textViewHeight)
        descriptionTextViewHeightConstraint?.isActive = true

        cancelButton.setConstraints(containerView.leadingAnchor, 0, nil, 40 , containerView.centerXAnchor,0 , containerView.bottomAnchor ,0)
        addButton.setConstraints(containerView.centerXAnchor, 0, nil, 40,containerView.trailingAnchor,0 , containerView.bottomAnchor,0)
    }
    
    func present() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self)
            self.setConstraints(window.leadingAnchor, 0, window.topAnchor, 0 , window.trailingAnchor, 0 , window.bottomAnchor ,0)
        }
    }
    
    func containerViewPerfectHeight() -> CGFloat {
        let containerWidth = containerView.frame.width
        
        let addRemainderTitleHeight = (topTitleLabel.text ?? "").size(withMaximumWidth: containerWidth, font: topTitleLabel.font).height
        
        let titleLabelHeight = (titleLabel.text ?? "").size(withMaximumWidth: containerWidth, font: titleLabel.font).height
        let titleTextFieldHeight = "".size(withMaximumWidth: containerWidth, font: titleTextField.font!).height + 10
        
        let descriptionLabelHeight = (descriptionLabel.text ?? "").size(withMaximumWidth: containerWidth, font: descriptionLabel.font!).height
        let descriptionTextViewHeight = descriptionTextView.text.size(withMaximumWidth: containerWidth - 30, font: descriptionTextView.font!).height + 10
        
        let buttonsHeight : CGFloat = 40
        let spaces : CGFloat = 70
        
        let newHeight = addRemainderTitleHeight + titleLabelHeight + titleTextFieldHeight + descriptionLabelHeight + descriptionTextViewHeight + buttonsHeight + spaces
        return newHeight
    }
    
    @objc func didCancel() {
        self.removeFromSuperview()
    }
    
    @objc func didAdd() {
        let title = titleTextField.text ?? ""
        let validTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !validTitle.isEmpty {
            let description : String? = !(self.descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty ? self.descriptionTextView.text : nil
            var alertInfo : Dictionary<String , Any> = [:]
            alertInfo[titleAlertKey] = title
            alertInfo[descriptionAlertKey] = description
            self.delegate?.alertView(self, didAdd: alertInfo)
        }else {
            shakeView(titleLabel)
        }
    }
    
    func shakeView(_ view : UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))
        
        view.layer.add(animation, forKey: "position")
    }
    
    
    deinit {
        print("deinit remainder view")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK:- TextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        let newHeight = textView.text.size(withMaximumWidth: containerView.frame.width - 30, font: textView.font!).height + 10
        if Int(newHeight) != Int(textView.frame.height) , newHeight <= maximumDecriptionTextViewHeight{
            self.descriptionTextViewHeightConstraint?.constant = newHeight
            self.containerViewHeightConstraint?.constant = containerViewPerfectHeight()
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
        
    }
    
    
    //MARK: - Themed
    
    func applyTheme(_ theme: Theme) {
        self.containerView.backgroundColor = theme.secondaryBackgroundColor
        self.topTitleLabel.textColor = theme.labelColor
        self.titleLabel.textColor = theme.labelColor
        self.titleTextField.textColor = theme.labelColor
        self.descriptionLabel.textColor = theme.labelColor
        self.descriptionTextView.textColor = theme.labelColor
        
        addButton.setTitleColor(theme.appTintColor, for: .normal)
        cancelButton.setTitleColor(theme.appTintColor, for: .normal)
        
        addButton.layer.borderColor = theme.tertiaryLabelColor.cgColor
        cancelButton.layer.borderColor = theme.tertiaryLabelColor.cgColor
        
        titleTextField.layer.borderColor = theme.tertiaryLabelColor.cgColor
        descriptionTextView.layer.borderColor = theme.tertiaryLabelColor.cgColor
    }
}


