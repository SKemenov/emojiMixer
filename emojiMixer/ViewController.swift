//
//  ViewController.swift
//  emojiMixer
//
//  Created by Sergey Kemenov on 04.10.2023.
//

import UIKit

// MARK: - Class ViewController

class ViewController: UIViewController {
  // MARK: - Private properties

  private var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "cell")
    return collectionView
  }()

  private let emojis = [
    "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝",
    "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"
  ]

  private var visibleEmoji: [String] = []


  // MARK: - Inits

  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecircle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    if let navigatorBar = navigationController?.navigationBar {
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
      let undoButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(undoButtonClicked))
      navigatorBar.topItem?.setRightBarButton(addButton, animated: true)
      navigatorBar.topItem?.setLeftBarButton(undoButton, animated: true)
    }
    setupCollectionView()

  }
}

// MARK: - Private methods

private extension ViewController {
  func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ])

  }

  @objc func addButtonClicked() {
    guard visibleEmoji.count < emojis.count else { return }
    let index = visibleEmoji.count
    visibleEmoji.append(emojis[index])
    collectionView.performBatchUpdates {
      collectionView.insertItems(at: [IndexPath(row: index, section: 0)])
    }
  }

  @objc func undoButtonClicked() {
    guard !visibleEmoji.isEmpty else { return }
    let lastIndex = visibleEmoji.count - 1
    visibleEmoji.removeLast()
    collectionView.performBatchUpdates {
      collectionView.deleteItems(at: [IndexPath(row: lastIndex, section: 0)])
    }
  }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return visibleEmoji.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiCell else { return UICollectionViewCell() }
    cell.titleEmoji.text = visibleEmoji[indexPath.row]
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width / 2 - 5
    return CGSize(width: width, height: width / 2)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
}

// MARK: - Class EmojiCell

class EmojiCell: UICollectionViewCell {
  // MARK: - Public properties

  let titleEmoji: UILabel = {
    $0.font = UIFont.systemFont(ofSize: 36)
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UILabel(frame: .zero))

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleEmoji)

    NSLayoutConstraint.activate([
      titleEmoji.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleEmoji.topAnchor.constraint(equalTo: topAnchor),
      titleEmoji.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
