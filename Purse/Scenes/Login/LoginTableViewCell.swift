import UIKit

protocol LoginTableViewCellInfoDisplayProtocol
{
    func display(info: String)
    func getTextFieldInfo() -> String? 
}

class LoginTableViewCell: UITableViewCell, LoginTableViewCellInfoDisplayProtocol {
    
    static let reuseId = "LoginTableViewCell_reuseId"
    
    @IBOutlet private weak var infoLabel: UILabel!
    
    @IBOutlet private weak var textField: UITextField!
    
    func display(info: String) {
        infoLabel.text = info
    }
    
    func getTextFieldInfo() -> String? {
        return textField.text
    }
}
