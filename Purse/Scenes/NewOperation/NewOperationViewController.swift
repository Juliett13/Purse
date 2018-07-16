import UIKit

protocol NewOperationViewProtocol: class {
    func setConfiguration(firstAccountLabelText: String, secondAccountLabelText: String, secondAccountIsHidden: Bool) 
}

class NewOperationViewController: UIViewController, NewOperationViewProtocol {
   
    static let reuseId = "NewOperationViewController_reuseId"
  
    @IBOutlet private weak var firstAccountPickerView: UIPickerView!
    @IBOutlet private weak var sumTextField: UITextField!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var operationTypeSegmentControl: UISegmentedControl!
    @IBOutlet private weak var firstAccountLabel: UILabel!
    @IBOutlet private weak var constraint: NSLayoutConstraint!
    @IBOutlet private weak var secondAccountLabel: UILabel!
    @IBOutlet private weak var secondAccountPickerView: UIPickerView!
    
    var presenter: NewOperationPresenterProtocol!
    var minDistance: CGFloat = 10
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func operationTypeChanged(_ sender: Any) {
        presenter.operationTypeChanged(id: operationTypeSegmentControl.selectedSegmentIndex)
    }
    
    func setConfiguration(firstAccountLabelText: String, secondAccountLabelText: String, secondAccountIsHidden: Bool) {
        let maxDistance = 3 * minDistance + secondAccountPickerView.layer.frame.height + secondAccountLabel.layer.frame.height
        let verticalSpacing = secondAccountIsHidden ? minDistance : maxDistance
        firstAccountLabel.text = firstAccountLabelText
        secondAccountLabel.text = secondAccountLabelText
        secondAccountLabel.isHidden = secondAccountIsHidden
        secondAccountPickerView.isHidden = secondAccountIsHidden
        constraint.constant = verticalSpacing
    }
    
    override func viewDidLoad() {
        operationTypeSegmentControl.selectedSegmentIndex = presenter.operationType
    }
    
    override func viewDidLayoutSubviews() {
        presenter.prepareView()
    }
}
