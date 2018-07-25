import Foundation
import UIKit

// REVIEW: Fanfastic, with extensions code is mush more readable.

class AccountsViewController: UIViewController, OperationTypesViewProtocol, Reusable {
 
    var presenter: AccountsPresenterProtocol!
    var configurator: AccountsConfiguratorProtocol!

    private var accountsButton = DropDownButton()
    var operationTypesView: OperationTypesView!
    
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var operationTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var operationsTableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(view: self)
        navigationItem.hidesBackButton = true
        accountsButton = DropDownButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        accountsButton.delegate = self
        self.view.addSubview(accountsButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.prepareView()
    }
    
    override func updateViewConstraints() {
        let btnWidth = 200.0
        let btnHeight = 60.0
        
        accountsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountsButton.widthAnchor.constraint(equalToConstant: CGFloat(btnWidth)).isActive = true
        accountsButton.heightAnchor.constraint(equalToConstant: CGFloat(btnHeight)).isActive = true
        
        let verticalConstraint = NSLayoutConstraint(item: sumLabel, attribute: NSLayoutAttribute.bottomMargin, relatedBy: NSLayoutRelation.equal, toItem: accountsButton, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: -10)
        self.view.addConstraint(verticalConstraint)
        verticalConstraint.isActive = true
        accountsButton.translatesAutoresizingMaskIntoConstraints = false
        super.updateViewConstraints()
    }
}

// MARK: - IBActions

extension AccountsViewController
{
    @IBAction func operationsButtonPressed(_ sender: Any) {
        if operationTypesView == nil {
            presenter.configureOperationTypesView()
        }
        operationTypesView.show(in: self)
    }
    @IBAction func operationTypeChanged(_ sender: Any) {
        presenter.operationTypeDidChanged(operationTypeSegmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        // logout
    }
}

// MARK: - AccountsViewProtocol

extension AccountsViewController: AccountsViewProtocol {
    func setOperationTypesConfiguration(onIncomePressed: @escaping () -> ()?, onOutgoPressed: @escaping () -> ()?, onTransferPressed: @escaping () -> ()?) {
        operationTypesView = OperationTypesView()
        operationTypesView.onIncomePressed = onIncomePressed
        operationTypesView.onOutgoPressed = onOutgoPressed
        operationTypesView.onTransferPressed = onTransferPressed
    }
    
    func setAccountsConfiguration(with title: String, dropDownOptions: [String]) {
//        accountsButton.setTitle(title, for: .normal) // !!??????
        accountsButton.setOptions(dropDownOptions)
    }
    
    func updateOperations() {
        operationsTableView.reloadData()
    }
    
    func updateSum(value: String) {
        sumLabel.text = value
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.operationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: OperationTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            return UITableViewCell()
        }
        let info = presenter.getInfo(for: indexPath.row)
        let sum = presenter.getSum(for: indexPath.row)
        cell.configure(info: info, sum: sum)
        return cell
    }
}

// MARK: - dropDownButtonProtocol

extension AccountsViewController: DropDownButtonProtocol {
    func editingDidEnd(with rowValue: Int) {
        presenter.accountIdDidChanged(rowValue)
    }
}


