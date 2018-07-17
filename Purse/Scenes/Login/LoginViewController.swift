import UIKit

protocol LoginViewProtocol: class {
    func setButtonTitle(text: String)
    func showAlert(with message: String)
    func getCell(by row: Int) -> LoginTableViewCellInfoDisplayProtocol
}

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
    
    func setButtonTitle(text: String) {
        button.setTitle(text, for: .normal) 
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fieldsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoginTableViewCell.reuseId, for: indexPath) as! LoginTableViewCell
        presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
    
    func getCell(by row: Int) -> LoginTableViewCellInfoDisplayProtocol {
        let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! LoginTableViewCell
        return cell
    }
}
