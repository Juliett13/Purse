import Foundation
import UIKit

class MainViewController: UIViewController, OperationsViewProtocol {

    var operationsView: OperationsView!

    var accountsButton = dropDownButton()
    
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBAction func operationsButtonPress(_ sender: Any) {
      
        guard operationsView == nil else {
            return
        }
        
        operationsView = OperationsView()
        
        operationsView?.onIncomePress = {

            self.operationsView = nil
            self.pushNewOperationVC(with: NewOperationViewController.operations.income.rawValue)
            
        }
        
        operationsView?.onOutcomePress = {

            self.operationsView = nil
            self.pushNewOperationVC(with: NewOperationViewController.operations.outgo.rawValue)

        }
        
        operationsView?.onTransferPress = {

            self.operationsView = nil
            self.pushNewOperationVC(with: NewOperationViewController.operations.transfer.rawValue)

        }

        operationsView?.onCancel = {
            
            self.operationsView = nil
            
        }

        operationsView.show(in: self)
    }
    
    func pushNewOperationVC(with operationType: Int) {
        let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: NewOperationViewController.reuseId) as! NewOperationViewController
        targetViewController.operationType = operationType
        self.navigationController?.pushViewController(targetViewController, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnWidth = 200.0
        let btnHeight = 60.0
        
        accountsButton = dropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        accountsButton.setTitle("Accounts", for: .normal)
        accountsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(accountsButton)
        
        accountsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountsButton.widthAnchor.constraint(equalToConstant: CGFloat(btnWidth)).isActive = true
        accountsButton.heightAnchor.constraint(equalToConstant: CGFloat(btnHeight)).isActive = true

        let verticalConstraint = NSLayoutConstraint(item: sumLabel, attribute: NSLayoutAttribute.bottomMargin, relatedBy: NSLayoutRelation.equal, toItem: accountsButton, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: -10)
        self.view.addConstraint(verticalConstraint)
        verticalConstraint.isActive = true
        
        accountsButton.dropView.dropDownOptions = ["Acc1", "Acc2", "Acc3"] //
    }
}



extension MainViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OperationTableViewCell.reuseId, for: indexPath) as! OperationTableViewCell
        cell.configure(for: "", and: 1)
        return cell
    }
}
