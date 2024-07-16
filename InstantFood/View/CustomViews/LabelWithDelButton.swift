//
//  LabelWithDelButton.swift
//  InstantFood
//
//  Created by Macbook Pro on 10/07/2024.
//

import UIKit

protocol LabelWithDelButtonDelegate {
    func didDeleteLabel(with text: String)
}

class LabelWithDelButton: UIView {
  
    var delegate : LabelWithDelButtonDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let deleteButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("x", for: .normal)
          button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
          button.tintColor = UIColor.red
          button.isUserInteractionEnabled = true
          return button
      }()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         commonInit()
     }

     private func commonInit() {
         
         deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
         addSubview(label)
         addSubview(deleteButton)
         setupConstraints()
     }

     func configure(with text: String) {
         label.text = text
     }
    
    private func setupConstraints() {
           label.translatesAutoresizingMaskIntoConstraints = false
           deleteButton.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               label.topAnchor.constraint(equalTo: topAnchor),
               label.leadingAnchor.constraint(equalTo: leadingAnchor),
               label.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5),
               label.bottomAnchor.constraint(equalTo: bottomAnchor),

               deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
               deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
               deleteButton.widthAnchor.constraint(equalToConstant: 26),
               deleteButton.heightAnchor.constraint(equalToConstant: 28)
           ])
       }
    
    @objc func deleteButtonTapped() {
        delegate?.didDeleteLabel(with: label.text ?? "")
        removeFromSuperview()
    }
}
