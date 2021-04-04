import UIKit

final class DLViewController: UIViewController {
    private var viewModel: DLViewModel?

    var navHeight: CGFloat {
        navigationController?.navigationBar.frame.height ?? 0.0 + statusBarHeight
    }

    var statusBarHeight: CGFloat {
        UIApplication.shared.statusBarFrame.height
    }

    private lazy var widgetView: DLWidgetView = {
        let view = DLWidgetView(frame: CGRect(x: 0, y: statusBarHeight + navHeight, width: viewWidth, height: viewHeight))
        view.backgroundColor = .blue
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "4xn Widget"
        view.backgroundColor = .cyan

        setUpView()

        viewModel = DLViewModel(completion: { [weak self] response in
            guard let self = self else { return }
            guard let response = response else { return }
            switch response {
            case let .response(model):
                DispatchQueue.main.async {
                    self.widgetView.configView(data: model, stateNumber: self.getInitialRandomState)
                    self.widgetView.isHidden = false
                }
            case let .error(error):
                self.createAlert(msg: error)
            }
        })
        viewModel?.fetchData()
    }

    // show alert in case of error response
    private func createAlert(msg: String) {
        DispatchQueue.main.async {
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Alert!",
                                                  message: msg,
                                                  preferredStyle: .alert)

            // Create OK button with action handler
            let okAction = UIAlertAction(title: "Okay",
                                         style: .default,
                                         handler: nil)

            // Add OK button to a dialog message
            dialogMessage.addAction(okAction)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
}

private extension DLViewController {
    func setUpView() {
        view.addSubview(widgetView)
        widgetView.delegate = self
    }

    var viewWidth: CGFloat {
        view.frame.width
    }

    var viewHeight: CGFloat {
        view.frame.height
    }
}

extension DLViewController {
    // 0 -> State 1, 1-> State 2, 2-> State 3
    // return random state 1 or 2
    var getInitialRandomState: Int {
        let randomInt = Int.random(in: 0...1)
        return randomInt
    }
}

extension DLViewController: RandomStateDelegate {
    // returns random state 1 or 3
    // no change in frame if the same state as getInitialRandomState() is returned
    func getRandomState() -> Int {
        let arr = [0, 2]
        let randNo = arr.randomElement() ?? 0
        return randNo
    }
}
