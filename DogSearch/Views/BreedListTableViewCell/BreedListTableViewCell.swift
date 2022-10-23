//
//  BreedListTableViewCell.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import UIKit

final class BreedListTableViewCell: UITableViewCell {
  
  //MARK: - Variables
  static let reuseIdentifier = "BreedListTableViewCell"
  private var constraintList = [NSLayoutConstraint]()
  
  private var breedsLabel = UILabel()
  
  //MARK: - Views Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(breedsLabel)
    configureBreedsLabel()
    breedsLabelConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Configure UILabel
  private func configureBreedsLabel() {
    breedsLabel.numberOfLines = 0
    breedsLabel.adjustsFontSizeToFitWidth = true
  }
  
  //MARK: - Configure UILabel Constraints
  private func breedsLabelConstraints() {
    breedsLabel.translatesAutoresizingMaskIntoConstraints = false
    breedsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    breedsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    breedsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
  }
  
  //MARK: - Configure cell
  func configure(with breed: String) {
    breedsLabel.text = "Dog breed: \(breed)"
  }
}
