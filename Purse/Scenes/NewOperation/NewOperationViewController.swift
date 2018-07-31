import UIKit

class NewOperationViewController: UIViewController, Reusable {
   
    var presenter: NewOperationPresenterProtocol!
    var configurator: NewOperationConfiguratorProtocol!

    @IBOutlet private weak var firstAccountPickerView: UIPickerView!
    @IBOutlet private weak var sumTextField: UITextField!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var operationTypeSegmentControl: UISegmentedControl!
    @IBOutlet private weak var firstAccountLabel: UILabel!
    @IBOutlet private weak var constraint: NSLayoutConstraint!
    @IBOutlet private weak var secondAccountLabel: UILabel!
    @IBOutlet private weak var secondAccountPickerView: UIPickerView!
    
    var minDistance: CGFloat = 10
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        let backButton = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: nil,
            action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        firstAccountPickerView.dataSource = self
        secondAccountPickerView.dataSource = self
        
        firstAccountPickerView.delegate = self
        secondAccountPickerView.delegate = self
        
        firstAccountPickerView.tag = presenter.firstAccountTag
        secondAccountPickerView.tag = presenter.secondAccountTag
        
        sumTextField.tag = presenter.sumTag
        commentTextField.tag = presenter.commentTag
        
        sumTextField.delegate = self
        commentTextField.delegate = self
        
        operationTypeSegmentControl.selectedSegmentIndex = OperationModel.types.index(of: presenter.operationType) ?? 0
        presenter.prepareView()

        guard let transferIndex = OperationModel.types.index(of: .transfer) else {
            return
        }
        operationTypeSegmentControl.setEnabled(presenter.allowTransfer, forSegmentAt: transferIndex)
    }
    
    override func viewDidLayoutSubviews() {
        presenter.prepareView()
    }
}

// MARK: - IBActions

extension NewOperationViewController {
    @IBAction func operationTypeChanged(_ sender: Any) {
        presenter.operationTypeChanged(id: operationTypeSegmentControl.selectedSegmentIndex)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        presenter.savePressed()
    }
}

// MARK: - NewOperationViewProtocol

extension NewOperationViewController: NewOperationViewProtocol {
    func setConfiguration(firstAccountLabelText: String,
                          secondAccountLabelText: String,
                          secondAccountIsHidden: Bool) {
        let maxDistance = 3 * minDistance + secondAccountPickerView.layer.frame.height + secondAccountLabel.layer.frame.height
        let verticalSpacing = secondAccountIsHidden ? minDistance : maxDistance
        firstAccountLabel.text = firstAccountLabelText
        secondAccountLabel.text = secondAccountLabelText
        secondAccountLabel.isHidden = secondAccountIsHidden
        secondAccountPickerView.isHidden = secondAccountIsHidden
        constraint.constant = verticalSpacing
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

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension NewOperationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return presenter.accountsCount
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return presenter.accountName(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        presenter.didSelectAccount(tag: pickerView.tag, row: row)
    }
}

// MARK: - UITextFieldDelegate

extension NewOperationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return presenter.shouldChangeCharacters(
            in: range, replacementString: string,
            tag: textField.tag)
    }
}
