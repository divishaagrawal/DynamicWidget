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
    private var builder: ViewBuilder?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension DLWidgetView {
    func setFrameData(stateInfo: [String], data: LayoutModel.ViewModel) {
        removeAllSubviews()

        let builder = ViewBuilder()
            .setFrame(bounds)
            .setData(data: data)
            .setButtonTarget(for: self)

        for item in stateInfo {
            if let attr = Attributes(rawValue: item) {
                builder.addAttribute(attr)
            }
        }
        let view = builder.build()
        addSubview(view)
        self.builder = builder
        frame.size.height = view.frame.size.height
    }
}

extension DLWidgetView {
    func configView(data: LayoutModel, stateNumber: Int) {
        self.data = data
        stateN = stateNumber
    }

    @objc func getRandomState() {
        builder?.animateButton { [weak self] in
            self?.stateN = self?.delegate?.getRandomState()
        }
    }
}
