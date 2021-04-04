import UIKit

class InitialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton(_ sender: Any) {
        let viewController = DLViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
