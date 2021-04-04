import UIKit

final class ViewBuilder {
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

    private(set) var frame: CGRect = .zero
    private(set) var attributes: [Attributes] = []
    private(set) var target: DLWidgetView?
    private(set) var data: LayoutModel.ViewModel?
    private var subtitleY: CGFloat = 0.0
}

extension ViewBuilder {
    func addAttribute(_ attr: Attributes) {
        attributes.append(attr)
    }

    func setFrame(_ frame: CGRect) -> ViewBuilder {
        self.frame = frame
        return self
    }

    func setButtonTarget(for target: DLWidgetView) -> ViewBuilder {
        self.target = target
        return self
    }

    func setData(data: LayoutModel.ViewModel) -> ViewBuilder {
        self.data = data
        return self
    }

    func build() -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .blue
        for item in attributes {
            view.addSubview(generateView(attr: item))
        }
        view.frame.size.height = calcHeight()
        return view
    }

    func animateButton(actionClosure: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.button.backgroundColor = .gray
        } completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.button.backgroundColor = .clear
            actionClosure()
        }
    }
}

private extension ViewBuilder {
    // build title
    func buildTitle() -> UIView {
        let height = getViewHeight(constrainedWidth: frame.width / 3, text: data?.title ?? "")
        subtitleY = (height + 1 + 16) // 1-> border width, 16-> spacing between labels
        let frame = CGRect(x: self.frame.width / 3,
                           y: 0.0,
                           width: self.frame.width / 3,
                           height: height)

        titleLabel.frame = frame
        titleLabel.text = data?.title
        return titleLabel
    }

    // build subtitle
    func buildsubTitle() -> UIView {
        let height = getViewHeight(constrainedWidth: frame.width / 3, text: data?.subtitle ?? "")
        let frame = CGRect(x: self.frame.width / 3,
                           y: subtitleY,
                           width: self.frame.width / 3,
                           height: height)

        subtitleLabel.frame = frame
        subtitleLabel.text = data?.subtitle
        return subtitleLabel
    }

    // build button
    func buildButton() -> UIView {
        let height = getViewHeight(constrainedWidth: frame.width / 3, text: data?.title ?? "")
        button = createButton()
        if let target = target {
            button.addTarget(target, action: #selector(DLWidgetView.getRandomState), for: .touchUpInside)
        }
        let frame = CGRect(x: self.frame.width / 3 * 2 + 1, // frame.wdth / 3*2 + 1 -> getting the  x coordinate for the third part of frame
                           y: 0.0,
                           width: self.frame.width / 3,
                           height: height)

        button.frame = frame
        button.setTitle(data?.button, for: .normal)
        return button
    }

    // build alert
    func buildAlert() -> UIView {
        let height = getViewHeight(constrainedWidth: frame.width / 3, text: data?.alert ?? "")
        subtitleY = (height + 1 + 16) // 1-> border width, 16-> spacing between labels
        let frame = CGRect(x: self.frame.width / 3 * 2 + 1, // frame.wdth / 3*2 + 1 -> getting the  x coordinate for the third part of frame
                           y: subtitleY,
                           width: self.frame.width / 3,
                           height: height)

        alertText.frame = frame
        alertText.text = data?.alert
        return alertText
    }

    // build image
    func buildImage() -> UIView {
        let frame = CGRect(x: 0.0,
                           y: 0.0,
                           width: self.frame.width / 3,
                           height: self.frame.width / 3)

        imageView.frame = frame
        return imageView
    }

    // returns view according to the attribute supplied
    private func generateView(attr: Attributes) -> UIView {
        switch attr {
        case .title:
            return buildTitle()

        case .subtitle:
            return buildsubTitle()

        case .image:
            return buildImage()

        case .alert:
            return buildAlert()

        case .button:
            return buildButton()
        }
    }

    // calculates the height for view based on the width provided
    func getViewHeight(constrainedWidth: CGFloat, text: String) -> CGFloat {
        let height = text.height(withConstrainedWidth: constrainedWidth,
                                 font: .boldSystemFont(ofSize: ViewDimensionConstant.twenty))
        return height
    }

    // returning height of imageview as the view's height cannot be greater than the imageView's height
    func calcHeight() -> CGFloat {
        return imageView.frame.height
    }
}
