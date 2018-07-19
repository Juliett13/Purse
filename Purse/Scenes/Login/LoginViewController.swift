import UIKit


class LoginViewController: UIViewController, LoginViewProtocol {
 
    static let reuseId = "LoginViewController_reuseId"
    var presenter: LoginPresenterProtocol!

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var tableView: UITableView!
   
    @IBAction func loginButtonPressed(_ sender: Any) {
        presenter.tryLogin()
    }
    
    override func viewDidLoad() {
        presenter.configureButton()
    }
}

// MARK: - LoginViewProtocol

extension LoginViewController
{
    func setButtonTitle(text: String) {
        button.setTitle(text, for: .normal) 
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fieldsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoginTableViewCell.reuseId, for: indexPath) as? LoginTableViewCell else {
            return UITableViewCell()
        }
        presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
    
    func getCell(by row: Int) -> LoginTableViewCellInfoDisplayProtocol {
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? LoginTableViewCell else {
            return LoginTableViewCell()
        }
        return cell
    }
}
