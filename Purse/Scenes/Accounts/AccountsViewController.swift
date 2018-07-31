import Foundation
import UIKit

class AccountsViewController: UIViewController, OperationTypesViewProtocol, Reusable {

    var presenter: AccountsPresenterProtocol!
    var configurator: AccountsConfiguratorProtocol!
    var operationTypesView: OperationTypesView!

    private var accountsButton: DropDownButton!
    private var tap: UIGestureRecognizer!

    @IBOutlet private weak var operationsButton: UIBarButtonItem!
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var operationTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var operationsTableView: UITableView!
    @IBOutlet weak var exitButton: UIBarButtonItem!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true

        configureAccountsButton()
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

        let verticalConstraint = NSLayoutConstraint(
            item: sumLabel,
            attribute: NSLayoutAttribute.bottomMargin,
            relatedBy: NSLayoutRelation.equal,
            toItem: accountsButton,
            attribute: NSLayoutAttribute.topMargin,
            multiplier: 1, constant: -10)
        self.view.addConstraint(verticalConstraint)
        verticalConstraint.isActive = true
        accountsButton.translatesAutoresizingMaskIntoConstraints = false
        accountsButton.didLayoutInSuperview()

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
        presenter.operationsButtonPressed()
    }
    @IBAction func operationTypeChanged(_ sender: Any) {
        presenter.operationTypeDidChanged(operationTypeSegmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        presenter.logout()
    }
}

// MARK: - AccountsViewProtocol

extension AccountsViewController: AccountsViewProtocol {
    func setOperationTypesConfiguration(onIncomePressed: @escaping () -> ()?,
                                        onOutgoPressed: @escaping () -> ()?,
                                        onTransferPressed: @escaping () -> ()?,
                                        viewWasHidden: @escaping () -> ()?) {

        operationTypesView = OperationTypesView()
        operationTypesView.onIncomePressed = onIncomePressed
        operationTypesView.onOutgoPressed = onOutgoPressed
        operationTypesView.onTransferPressed = onTransferPressed
        operationTypesView.viewWasHidden = viewWasHidden
    }

    func setAccountsButtonTitle(_ title: String) {
        accountsButton.setTitle(title, for: .normal)
    }

    func setAccountsConfiguration(_ dropDownOptions: [String]) {
        accountsButton.setOptions(dropDownOptions)
    }

    func allowNewOperation() {
        operationsButton.isEnabled = presenter.allowNewOperation
    }
    
    func updateOperations() {
        operationsTableView.reloadData()
    }
    
    func updateSum(value: String) {
        sumLabel.text = value
    }

    func setHidesOperationsButton(_ hidesOperationsButton: Bool) {
        operationsButton.isEnabled = !hidesOperationsButton
    }

    func showAlert(with message: String,
                   yesHandler: (() -> ())?,
                   cancelHandler: (() -> ())?) {

        let alert = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(
            title: "Да",
            style: .default,
            handler: { _ in
                yesHandler?()
        }))

        alert.addAction(UIAlertAction(
            title: "Отмена",
            style: .default,
            handler: { _ in
                cancelHandler?()
        }))
        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.operationsCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell: OperationTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
            return UITableViewCell()
        }
        let info = presenter.getInfo(for: indexPath.row)
        let sum = presenter.getSum(for: indexPath.row)
        cell.configure(info: info, sum: sum)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - DropDownButtonProtocol

extension AccountsViewController: DropDownButtonProtocol {
    func viewDidDisappear() {
        tap.isEnabled = false
        setControlsState(true)
    }

    func viewWillAppear() {
        tap.isEnabled = true
        setControlsState(false)
    }

    func editingDidEnd(with rowValue: Int) {
        presenter.accountIdDidChanged(rowValue)
    }

    private func setControlsState(_ areEnable: Bool) {
        operationTypeSegmentedControl.isEnabled = areEnable
        exitButton.isEnabled = areEnable
        if areEnable {
            allowNewOperation()
        } else {
            operationsButton.isEnabled = areEnable
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension AccountsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return false
        }
        return !view.isDescendant(of: accountsButton.dropView)
    }

    private func configureAccountsButton() {
        accountsButton = DropDownButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        accountsButton.delegate = self
        self.view.addSubview(accountsButton)
        tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handleOutsideTap))
        tap.delegate = self
        tap.isEnabled = false
        self.view.addGestureRecognizer(tap)

        let borderColor = UIColor(
            red: 121.0 / 255.0,
            green: 190.0 / 255.0,
            blue: 112.0 / 255.0,
            alpha: 1)

        let normalBackgroundColor = UIColor.white.cgColor

        let focusedBackgoundColor = UIColor(
            red: 250.0 / 255.0,
            green: 250.0 / 255.0,
            blue: 250.0 / 255.0,
            alpha: 1)

        accountsButton.configure(
            borderWidth: 1,
            cornerRadius: 15,
            borderColor: borderColor,
            normalBackgroundColor: normalBackgroundColor,
            focusedBackgoundColor: focusedBackgoundColor)
    }

    @objc private func handleOutsideTap(sender: UITapGestureRecognizer? = nil) {
        accountsButton.dismissDropDown()
    }
}
