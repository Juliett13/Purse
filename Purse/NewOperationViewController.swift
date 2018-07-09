import UIKit

class NewOperationViewController: UIViewController {
    
    static let reuseId = "NewOperationViewController_reuseId"
    
    public enum operations: Int {
        case income = 0
        case outgo = 1
        case transfer = 2
    }
    
    @IBOutlet weak var firstAccountPickerView: UIPickerView!
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var operationTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var firstAccountLabel: UILabel!
    
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var secondAccountLabel: UILabel!
    
    @IBOutlet weak var secondAccountPickerView: UIPickerView!
    
    
    var operationType = -1
    
    var distance: CGFloat = 10
    
    @IBAction func operationTypeChanged(_ sender: Any) {
        
        if (operationType == operations.transfer.rawValue) {
            transferDidDeselected()
        } else if (operationTypeSegmentControl.selectedSegmentIndex == operations.transfer.rawValue) {
            transferDidSelected()
        }
        
        operationType = operationTypeSegmentControl.selectedSegmentIndex
        
    }
    
    func transferDidSelected() {
     
        firstAccountLabel.text = "Счет списания"
        secondAccountLabel.text = "Счет пополнения"
        
        secondAccountLabel.isHidden = false
        secondAccountPickerView.isHidden = false
        
        constraint.constant = 3 * distance + secondAccountPickerView.layer.frame.height + secondAccountLabel.layer.frame.height 

        
    }
    
    func transferDidDeselected() {
        firstAccountLabel.text = "Счет"
        secondAccountLabel.isHidden = true
        secondAccountPickerView.isHidden = true
        constraint.constant = distance
    }

    
    override func viewDidLoad() {

        self.navigationItem.backBarButtonItem?.tintColor = .black
        operationTypeSegmentControl.selectedSegmentIndex = operationType

        if (operationType != operations.transfer.rawValue) {
            transferDidDeselected()
        }
    }
    
}
