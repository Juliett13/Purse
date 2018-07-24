import UIKit

protocol OperationTableViewCellInfoDisplayProtocol {
    func configure(info: String, sum: String) 
}

class OperationTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
}

// MARK: - OperationTableViewCellInfoDisplayProtocol

extension OperationTableViewCell: OperationTableViewCellInfoDisplayProtocol {
    func configure(info: String, sum: String) {
        infoLabel.text = info
        sumLabel.text = sum
    }
}
