//
//  StackViewForEditProfile.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 21.01.2024.
//

import UIKit

class StackViewForEditProfile: UIStackView {
    
    // MARK: Properties & UI Elements
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .sfProBold22
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .ypLightGray
        textView.font = .sfProRegular17
        textView.textColor = .ypBlack
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = Constants.cornerRadius
        textView.clipsToBounds = true
        textView.text = ""
        textView.textContainerInset = UIEdgeInsets(
            top: Constants.insetValue11,
            left: Constants.insetValue16,
            bottom: Constants.insetValue11,
            right: Constants.insetValue16
        )
        return textView
    }()
    
    private var currentText: String?
    
    // MARK: Lifecycle
    init(labelText: String, textContent: String) {
        super.init(frame: .zero)
        
        label.text = labelText
        textView.text = textContent
        currentText = textContent
        setupView()
    }
    
    required init(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    // MARK: Methods
    func updateText(_ text: String) {
        textView.text = text
        currentText = text
    }
    
    func getText() -> String? {
        return textView.text
    }
    
    private func setupView() {
        [label, textView].forEach { addArrangedSubview($0) }
        
        axis = .vertical
        spacing = 8
    }
    
    // MARK: Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let insetValue11: CGFloat = 11
        static let insetValue16: CGFloat = 16
    }
}
