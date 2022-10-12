//
//  MainDetailViewController.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit
import Kingfisher

final class MainDetailViewController: UIViewController {

  private lazy var photoDetailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "photo.circle")
    imageView.layer.shadowColor = UIColor.black.cgColor
    imageView.layer.shadowOpacity = 1
    imageView.layer.shadowOffset = .zero
    imageView.layer.shadowRadius = 10
    imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
    imageView.layer.shouldRasterize = true
    imageView.layer.rasterizationScale = UIScreen.main.scale
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var photoDetailTitleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = .boldSystemFont(ofSize: 16)
    titleLabel.numberOfLines = 0
    return titleLabel
  }()

  private lazy var photoDetailAuthorLabel: UILabel = {
    let authorLabel = UILabel()
    authorLabel.font = .systemFont(ofSize: 16)
    authorLabel.numberOfLines = 0
    return authorLabel
  }()

  private lazy var photoDetailURLLabel: UILabel = {
    let URLLabel = UILabel()
    URLLabel.font = .systemFont(ofSize: 16)
    URLLabel.numberOfLines = 0
    return URLLabel
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.spacing = 300
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  var detailViewModel: MainDetailViewModelProtocol!
  var mainDetailTitle: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    viewConstraints()
    detailViewModel.delegate = self
    detailViewModel.load()
  }

  private func viewConstraints() {
    stackView.addArrangedSubview(photoDetailImageView)
    stackView.addArrangedSubview(photoDetailTitleLabel)
    stackView.addArrangedSubview(photoDetailAuthorLabel)
    stackView.addArrangedSubview(photoDetailURLLabel)
    view.addSubview(stackView)

    var constraints = [NSLayoutConstraint]()

    //MARK: - StackView
    constraints.append(stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -250))
    constraints.append(stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -250))
    constraints.append(stackView.centerYAnchor.constraint(equalTo: view.topAnchor))
    constraints.append(stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5))

    //MARK: -ImageView
    photoDetailImageView.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(photoDetailImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7))
    constraints.append(photoDetailImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7))
    constraints.append(photoDetailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
    constraints.append(photoDetailImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70))

    //MARK: -TitleLabel
    photoDetailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(photoDetailTitleLabel.topAnchor.constraint(equalTo: photoDetailImageView.topAnchor, constant: 160))
    constraints.append(photoDetailTitleLabel.leadingAnchor.constraint(equalTo: photoDetailImageView.leadingAnchor))
    constraints.append(photoDetailTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor))
    constraints.append(photoDetailTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor))

    //MARK: - AuthorLabel
    photoDetailAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(photoDetailAuthorLabel.topAnchor.constraint(equalTo: photoDetailTitleLabel.topAnchor, constant: 70))
    constraints.append(photoDetailAuthorLabel.leadingAnchor.constraint(equalTo: photoDetailImageView.leadingAnchor))
    constraints.append(photoDetailAuthorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor))
    constraints.append(photoDetailAuthorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor))

    //MARK: - URLLabel
    photoDetailURLLabel.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(photoDetailURLLabel.topAnchor.constraint(equalTo: photoDetailAuthorLabel.topAnchor, constant: 70))
    constraints.append(photoDetailURLLabel.leadingAnchor.constraint(equalTo: photoDetailImageView.leadingAnchor))
    constraints.append(photoDetailURLLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor))
    constraints.append(photoDetailURLLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor))

    NSLayoutConstraint.activate(constraints)
  }
}

extension MainDetailViewController: MainDetailViewModelDelegate {
  func showDetail(_ presentation: MainDetailPresentation) {
    let imageURL = URL(string: presentation.thumbnail)
    photoDetailImageView.kf.setImage(with: imageURL)
    photoDetailTitleLabel.text = "Title: \(presentation.imageTitle)"
    photoDetailAuthorLabel.text = "Author: \(presentation.author)"
    photoDetailURLLabel.text = "Website: \(presentation.url)"
  }
}
