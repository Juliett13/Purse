import UIKit

protocol OperationTableViewCellInfoDisplayProtocol
{
    func display(info: String)
    func display(sum: Int)
}

class OperationTableViewCell: UITableViewCell, OperationTableViewCellInfoDisplayProtocol {
  
    static let reuseId = "OperationTableViewCell_reuseId"
    
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
    
    func display(info: String) {
        infoLabel.text = info
    }
    
    // REVIEW: Cell mustn't prepare final text from data, it's presenter's job.
    func display(sum: Int) {
        sumLabel.text = "\(sum)"
    }
}
