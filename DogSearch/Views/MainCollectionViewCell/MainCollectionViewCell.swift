//
//  MainCollectionViewCell.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit.UIImageView
import Kingfisher

final class MainCollectionViewCell: UICollectionViewCell {
  
  static let reuseIdentifier = "MainCollectionViewCell"
  
  public lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "photo.fill")
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 12
    imageView.clipsToBounds = true
    return imageView
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
    imageViewConstraints()
  }
  
  private func imageViewConstraints() {
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
  func configure(with image: Child) {
    let imageURL = URL(string: image.data.thumbnail)
    imageView.kf.setImage(with: imageURL)
  }
}
