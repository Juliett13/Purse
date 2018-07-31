import UIKit

class LoginViewController: UIViewController, Reusable {
 
    var presenter: LoginPresenterProtocol!
    var configurator: LoginConfiguratorProtocol!

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var tableView: UITableView!
   
    // MARK: - Lifecycle

    override func viewDidLoad() {

        let backButton = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: nil,
            action: nil)

        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        presenter.configureButton()
    }
}

// MARK: - IBActions

extension LoginViewController {
    @IBAction func loginButtonPressed(_ sender: Any) {
        presenter.tryLogin()
    }
}

// MARK: - LoginViewProtocol

extension LoginViewController: LoginViewProtocol {
    func setButtonTitle(text: String) {
        button.setTitle(text, for: .normal) 
    }
    
    func showAlert(with message: String,
                   handler: (() -> ()?)?) {

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

extension LoginViewController: UITextFieldDelegate {
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
            for: textField.tag)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.fieldsCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LoginTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            return UITableViewCell()
        }
        let fieldName = presenter.fieldName(for: indexPath.row)
        let isSecure = presenter.fieldIsSecure(for: indexPath.row)

        cell.configure(
            tag: indexPath.row,
            isSecure: isSecure,
            placeholder: fieldName)

        return cell
    }
}
