//
//  BreedListDetailTableViewCell.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-12.
//

import UIKit
import Foundation
import Combine

final class BreedListDetailTableViewCell: UITableViewCell {

  //MARK: - Variables
  static let reuseIdentifier = "BreedListDetailTableViewCell"
  private var constraintList = [NSLayoutConstraint]()

  private var breedImageView: UIImageView!
  private var favoriteButton: UIButton!
  private var animator: UIViewPropertyAnimator?

  private var breedImages: BreedImages?
  var index: IndexPath?

  // store publisher here
  var cancellable: AnyCancellable?

  // Single Publisher per cell
  let tapButton = PassthroughSubject<IndexPath?, Never>()

  private var fileManagerReadSavedURLs: [String]?

  //View Lifecycles
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: Add image to favorite button action
  @objc func favoriteAction() {
    favoriteButton.isSelected = !favoriteButton.isSelected
    favoriteButton.isSelected ? favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)

    tapButton.send(self.index)
  }

  //MARK: - Reusable cell
  override public func prepareForReuse() {
    super.prepareForReuse()
    animator?.stopAnimation(true)
    cancellable?.cancel()
  }

  //MARK: - Configure cell
  public func configure(with image: BreedImages, indexPath: IndexPath) {
    self.index = indexPath

    let breedImagesFromAPI = image.message[indexPath.row]

    do {
      fileManagerReadSavedURLs = try FileStorageManager.shared.readAllRemoteURLs()
      if fileManagerReadSavedURLs?.contains(breedImagesFromAPI) == true {
        self.favoriteButton.isSelected = true
        self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
      } else {
        self.favoriteButton.isSelected = false
        self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
      }
    } catch {
      print("Error when reading FM")
    }
    cancellable = loadImage(for: breedImagesFromAPI).sink { [unowned self] image in
      self.showImage(image: image)
    }
  }

  //MARK: - Show Detail View's Image
  private func showImage(image: UIImage?) {
    breedImageView.alpha = 0.0
    animator?.stopAnimation(false)
    breedImageView.image = image
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.breedImageView.alpha = 1.0
    })
    animator?.fractionComplete = 0.25
    animator?.stopAnimation(true)
    animator?.finishAnimation(at: .current)
  }

  //MARK: - Load Detail View Image
  private func loadImage(for breed: String) -> AnyPublisher<UIImage?, Never> {
    return Just(breed)
      .flatMap({ img -> AnyPublisher<UIImage?, Never> in
        guard let url = URL(string: breed) else { return Result.Publisher(nil).eraseToAnyPublisher() }
        return ImageLoader.shared.loadImage(from: url)
      })
      .eraseToAnyPublisher()
  }

  //MARK: - Setup UI Elements
  private func setupUI() {
    favoriteButton = UIButton()
    favoriteButton.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
    favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    favoriteButton.setTitleColor(.blue, for: .normal)
    favoriteButton.frame = CGRect(x: 15, y: -50, width: 50, height: 50)

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

    breedImageView = UIImageView()

    stackView.addArrangedSubview(breedImageView)
    stackView.addArrangedSubview(favoriteButton)
    NSLayoutConstraint.activate([
      breedImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -100),
      breedImageView.heightAnchor.constraint(equalToConstant: 230),
      favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 50),
      favoriteButton.heightAnchor.constraint(equalToConstant: 60),
      favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
    ])
  }
}
