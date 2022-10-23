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
    favoriteImageView.image = UIImage(systemName: "photo")
    animator?.stopAnimation(true)
    cancellable?.cancel()
  }
  
  //MARK: - Configure cell
  public func configure(with image: [String], indexPath: IndexPath) {
    self.index = indexPath
    
    if let range = image[indexPath.row].range(of: "Documents") {
      let phone = image[indexPath.row][range.upperBound...]
      if let rangeOfRange = phone.range(of: "/") {
        let finalBreedText = phone[rangeOfRange.upperBound...]
        self.breedLabel.text = "\(finalBreedText)"
      }
    }
    
    self.cancellable = self.loadImage(for: image[indexPath.row]).sink { [unowned self] image in
      self.showImage(image: image)
    }
  }
  
  //MARK: - Show Detail View's Image
  private func showImage(image: UIImage?) {
    favoriteImageView.alpha = 0.0
    animator?.stopAnimation(false)
    favoriteImageView.image = image
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.favoriteImageView.alpha = 1.0
    })
    animator?.fractionComplete = 0.25
    animator?.stopAnimation(true)
    animator?.finishAnimation(at: .current)
  }
  
  //MARK: - Load Favorite View Image
  private func loadImage(for favorite: String) -> AnyPublisher<UIImage?, Never> {
    return Just(favorite)
      .flatMap({ img -> AnyPublisher<UIImage?, Never> in
        guard let url = URL(string: favorite) else { return Result.Publisher(nil).eraseToAnyPublisher() }
        return ImageLoader.shared.loadImage(from: url)
      })
      .eraseToAnyPublisher()
  }
  
  //MARK: - Setup UI
  private func setupUI() {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
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
    breedLabel.font = .boldSystemFont(ofSize: 14)
    breedLabel.numberOfLines = 0
    breedLabel.lineBreakMode = .byWordWrapping
    
    stackView.addArrangedSubview(favoriteImageView)
    stackView.addArrangedSubview(breedLabel)
    NSLayoutConstraint.activate([
      favoriteImageView.widthAnchor.constraint(equalToConstant: 200),
      favoriteImageView.heightAnchor.constraint(equalToConstant: 200),
      breedLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30)
    ])
  }
}
