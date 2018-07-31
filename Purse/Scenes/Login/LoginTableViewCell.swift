import UIKit

protocol LoginTableViewCellInfoDisplayProtocol
{
    func configure(tag: Int, isSecure: Bool, placeholder: String) 
}

class LoginTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet private weak var textField: UITextField!
}

// MARK: - LoginTableViewCellInfoDisplayProtocol

extension LoginTableViewCell: LoginTableViewCellInfoDisplayProtocol {
    func configure(tag: Int,
                   isSecure: Bool,
                   placeholder: String) {
        textField.tag = tag
        textField.isSecureTextEntry = isSecure
        textField.placeholder = placeholder
    }
}
