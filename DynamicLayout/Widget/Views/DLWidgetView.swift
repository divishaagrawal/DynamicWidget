import UIKit

enum Attributes: String {
    case title
    case image
    case subtitle
    case button
    case alert
}

protocol RandomStateDelegate: AnyObject {
    func getRandomState() -> Int
}

final class DLWidgetView: UIView {
    weak var delegate: RandomStateDelegate?
    private var stateN: Int? {
        didSet {
            // if the same state as initial state is returned, frames will not be calculated again
            if let state = stateN, let data = data, state != oldValue {
                setFrameData(stateInfo: data.states[state], data: data.viewModel[state])
            }
        }
    }

    private var data: LayoutModel?

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: ViewDimensionConstant.twenty)
        titleLabel.layer.borderColor = UIColor.black.cgColor
        titleLabel.layer.borderWidth = 1.0
        return titleLabel
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: ViewDimensionConstant.twenty)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()

    private lazy var alertText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: ViewDimensionConstant.twenty)
        label.textColor = .red
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "bookmark")
        return imageView
    }()

    private lazy var button: UIButton = {
        createButton()
    }()

    func createButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.gray, for: .selected)
        return button
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension DLWidgetView {
    var viewWidth: CGFloat {
        bounds.width
    }

    var viewHeight: CGFloat {
        bounds.height
    }

    func setFrameData(stateInfo: [String], data: LayoutModel.ViewModel) {
        removeAllSubviews()
        var subtitleY: CGFloat = 0.0

        for item in stateInfo {
            switch item {
            case Attributes.title.rawValue:
                let height = getViewHeight(constrainedWidth: viewWidth / 3, text: data.title)
                subtitleY = (height + 1 + 16) // 1-> border width, 16-> spacing between labels
                let frame = CGRect(x: viewWidth / 3,
                                   y: 0.0,
                                   width: viewWidth / 3,
                                   height: height)

                titleLabel.frame = frame
                titleLabel.text = data.title
                addSubview(titleLabel)

            case Attributes.subtitle.rawValue:
                if let subtitle = data.subtitle {
                    let height = getViewHeight(constrainedWidth: viewWidth / 3, text: subtitle)
                    let frame = CGRect(x: viewWidth / 3,
                                       y: subtitleY,
                                       width: viewWidth / 3,
                                       height: height)

                    subtitleLabel.frame = frame
                    subtitleLabel.text = data.subtitle
                    addSubview(subtitleLabel)
                }

            case Attributes.image.rawValue:
                let frame = CGRect(x: 0.0,
                                   y: 0.0,
                                   width: viewWidth / 3,
                                   height: viewWidth / 3)
                imageView.frame = frame
                addSubview(imageView)

            case Attributes.alert.rawValue:
                if let alertText = data.alert {
                    let height = getViewHeight(constrainedWidth: viewWidth / 3, text: alertText)
                    let frame = CGRect(x: viewWidth / 3 * 2 + 1, // 1-> border width
                                       y: subtitleY,
                                       width: viewWidth / 3,
                                       height: height)

                    self.alertText.frame = frame
                    self.alertText.text = data.alert
                    addSubview(self.alertText)
                }
            case Attributes.button.rawValue:
                let button = createButton()
                self.button = button
                addSubview(button)
                button.addTarget(self, action: #selector(getRandomState), for: .touchUpInside)
                if let btnText = data.button {
                    let height = getViewHeight(constrainedWidth: viewWidth / 3, text: btnText)
                    let frame = CGRect(x: viewWidth / 3 * 2 + 1, // 1-> border width
                                       y: 0.0,
                                       width: viewWidth / 3,
                                       height: height)

                    button.frame = frame
                    button.setTitle(data.button, for: .normal)
                }
            default:
                break
            }
        }
    }

    func getViewHeight(constrainedWidth: CGFloat, text: String) -> CGFloat {
        let height = text.height(withConstrainedWidth: constrainedWidth,
                                 font: .boldSystemFont(ofSize: ViewDimensionConstant.twenty))
        return height
    }

    @objc func getRandomState() {
        UIView.animate(withDuration: 0.3) {
            self.button.backgroundColor = .gray
        } completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.button.backgroundColor = .clear
            self.stateN = self.delegate?.getRandomState()
        }
    }
}

extension DLWidgetView {
    func configView(data: LayoutModel, stateNumber: Int) {
        self.data = data
        stateN = stateNumber
    }

    // returning height of imageview as the view's height cannot be greater than the imageView's height
    func calcHeight() -> CGFloat {
        return imageView.frame.height
    }
}
