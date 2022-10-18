//
//  FavoriteDogListTableViewCell.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import UIKit
import Foundation
import Combine

class FavoriteDogListTableViewCell: UITableViewCell {

  static let reuseIdentifier = "FavoriteDogListTableViewCell"
  private var constraintList = [NSLayoutConstraint]()

  var favoriteImageView: UIImageView!
  var breedLabel: UILabel!

  var index: IndexPath?
  private var cancellable: AnyCancellable?
  private var animator: UIViewPropertyAnimator?

  //MARK: - Views Lifecycles
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func prepareForReuse() {
    super.prepareForReuse()
    showFavoriteImage()
    cancellable?.cancel()
  }

  //MARK: - Show Favorite Image
  private func showFavoriteImage() {
    favoriteImageView.alpha = 0.0
    breedLabel.alpha = 0.0
    animator?.stopAnimation(false)
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.favoriteImageView.alpha = 1.0
      self.breedLabel.alpha = 1.0
    })
    animator?.fractionComplete = 0.25
    animator?.stopAnimation(true)
    animator?.finishAnimation(at: .current)
  }

  //MARK: - Setup UI
  private func setupUI() {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.spacing = 8
    stackView.alignment = .leading
    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])

    favoriteImageView = UIImageView()
    breedLabel = UILabel()
    stackView.addArrangedSubview(favoriteImageView)
    stackView.addArrangedSubview(breedLabel)
    NSLayoutConstraint.activate([
      favoriteImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -100),
      favoriteImageView.heightAnchor.constraint(equalToConstant: 230),
      breedLabel.heightAnchor.constraint(equalToConstant: 40),
      breedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
    ])
  }
}
