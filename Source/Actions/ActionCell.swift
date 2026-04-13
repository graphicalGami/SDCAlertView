import UIKit

final class ActionCell: UICollectionViewCell {

    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.numberOfLines = 2
        label.baselineAdjustment = .alignBaselines
        label.minimumScaleFactor = 0.58
        label.font = .systemFont(ofSize: 17)
        label.isUserInteractionEnabled = false
        return label
    }()

    private var highlightedBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        view.alpha = 0.7
        view.isHidden = true
        return view
    }()

    private var textColor: UIColor?

    var isEnabled = true {
        didSet { titleLabel.isEnabled = isEnabled }
    }

    override var isHighlighted: Bool {
        didSet { highlightedBackgroundView.isHidden = !isHighlighted }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        clipsToBounds = true
        isMultipleTouchEnabled = true

        contentView.clipsToBounds = true
        contentView.isMultipleTouchEnabled = true

        contentView.addSubview(highlightedBackgroundView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            // highlightedBackgroundView — pinned to all 4 edges of cell
            highlightedBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            highlightedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            highlightedBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            highlightedBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // titleLabel — centered vertically, 12pt inset left and right
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }

    func set(_ action: AlertAction, with visualStyle: AlertVisualStyle) {
        action.actionView = self
        titleLabel.font = visualStyle.font(for: action)
        textColor = visualStyle.textColor(for: action)
        titleLabel.textColor = textColor ?? tintColor
        titleLabel.attributedText = action.attributedTitle
        highlightedBackgroundView.backgroundColor = visualStyle.actionHighlightColor
        setupAccessibility(using: action)
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        titleLabel.textColor = textColor ?? tintColor
    }
}

final class ActionSeparatorView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? ActionsCollectionViewLayoutAttributes {
            backgroundColor = attributes.backgroundColor
        }
    }
}
