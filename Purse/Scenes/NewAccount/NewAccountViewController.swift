import UIKit

class NewAccountViewController: UIViewController, Reusable {

    var presenter: NewAccountPresenterProtocol!
    var configurator: NewAccountConfiguratorProtocol!

    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        let backButton = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: nil,
            action: nil)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        accountNameTextField.delegate = self
        balanceTextField.delegate = self

        accountNameTextField.tag = presenter.accountNameTag()
        balanceTextField.tag = presenter.accountBalanceTag()
    }
}

// MARK: - Actions

extension NewAccountViewController {
    @IBAction func saveButtonPressed(_ sender: Any) {
        presenter.savePressed()
    }
}

// MARK: - NewAccountViewProtocol

extension NewAccountViewController: NewAccountViewProtocol {
    func showAlert(with message: String, handler: (() -> ()?)?) {
        let alert = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: {action in
                handler?()
        }))
        self.present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension NewAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return presenter.shouldChangeCharacters(
            in: range,
            replacementString: string,
            tag: textField.tag)
    }
}
