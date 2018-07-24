import UIKit

protocol OperationTypesViewProtocol {
    var operationTypesView: OperationTypesView! {get set}
}

class OperationTypesView: UIView, UIGestureRecognizerDelegate {
    var onIncomePressed: (() -> ()?)?
    var onOutgoPressed: (() -> ()?)?
    var onTransferPressed: (() -> ()?)?

    var visualEffectView: UIVisualEffectView!
    var containerView: UIView!
    
    let insideDistance = 25
    let buttonSize = 60

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        createVisualEffectView()
        self.addSubview(visualEffectView)

        createContainerView()
        visualEffectView.contentView.addSubview(containerView)
        
        createButtons()
    }
    
    private func createVisualEffectView() {
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleOutsideTap))
        tap.delegate = self
        visualEffectView.addGestureRecognizer(tap)
    }
    
    private func createContainerView() {
        let outsideDistance = (Int(UIScreen.main.bounds.width) - 3 * buttonSize - 4 * insideDistance) / 2
        containerView = UIView()
        containerView.frame = CGRect(x: Int(UIScreen.main.bounds.width) - buttonSize - 3 * outsideDistance, y: outsideDistance , width: buttonSize + 2 * insideDistance, height: buttonSize * 3 + insideDistance * 4)
        containerView.backgroundColor = UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 0.5)
        containerView.layer.cornerRadius = 35
    }
    
    private func createButtons() {
        let incomeButton = UIButton(frame: CGRect(x: insideDistance, y: insideDistance, width: buttonSize, height: buttonSize))
        
        let outgoButton = UIButton(frame: CGRect(x: insideDistance, y: 2 * insideDistance + buttonSize, width: buttonSize, height: buttonSize))
        
        let transferButton = UIButton(frame: CGRect(x: insideDistance, y: 3 * insideDistance + 2 * buttonSize, width: buttonSize, height: buttonSize))
        
        containerView.addSubview(incomeButton)
        containerView.addSubview(outgoButton)
        containerView.addSubview(transferButton)
        
        initButton(incomeButton)
        incomeButton.setImage(UIImage(named: ""), for: .normal) //
        
        initButton(outgoButton)
        outgoButton.setImage(UIImage(named: ""), for: .normal) //
        
        initButton(transferButton)
        transferButton.setImage(UIImage(named: ""), for: .normal) //
        
        incomeButton.addTarget(self, action: #selector(self.incomeButtonPressed), for: .touchUpInside)
        outgoButton.addTarget(self, action: #selector(self.outgoButtonPressed), for: .touchUpInside)
        transferButton.addTarget(self, action: #selector(self.transferButtonPressed), for: .touchUpInside)
    }
    
    private func initButton(_ btn: UIButton) {
        let btnColor = UIColor(displayP3Red: 136.0 / 255.0, green: 176.0 / 255.0, blue: 75.0 / 255.0, alpha: 1)
        btn.layer.borderColor = btnColor.cgColor
        btn.layer.borderWidth = 1
        btn.setTitleColor(.white, for: .normal)
        btn.layer.shadowRadius = 3
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 1.0
        btn.layer.cornerRadius = 10
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    typealias VC = UIViewController & OperationTypesViewProtocol
    func show(in vc: VC) {
        vc.view.addSubview(self)
        self.frame = vc.view.frame
        visualEffectView.frame = self.frame

        self.center = vc.view.center
        self.center.y -= UIApplication.shared.statusBarFrame.height
        
        if let navigationBarHeight = vc.navigationController?.navigationBar.bounds.height {
            self.center.y += navigationBarHeight
            containerView.frame.offsetBy(dx: navigationBarHeight, dy: 0)
        }
        
        visualEffectView.center = self.center
        
        let dx = vc.view.frame.width - self.containerView.layer.position.x
        let dy = -self.containerView.layer.position.y

        self.containerView.transform = CGAffineTransform(translationX: dx, y: dy).scaledBy(x: 0.1, y: 0.3)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations:  {
            self.alpha = 1
            self.visualEffectView.effect = UIBlurEffect(style: .light)
            self.containerView.transform = CGAffineTransform.identity
        })
        
    }
    
    func hide() {
        let dx = UIScreen.main.bounds.width - self.containerView.layer.position.x
        let dy = -self.containerView.layer.position.y
        self.containerView.transform = CGAffineTransform.identity

        let timeInterval = 0.3
        
        UIView.animate(withDuration: timeInterval, animations:  { 
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: dx, y: dy).scaledBy(x: 0.1, y: 0.3)
        })
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { t in
            self.removeFromSuperview()
        }
    }
    
    @objc func incomeButtonPressed(sender: UIButton) {
        self.onIncomePressed?()
        hide()
    }
    
    @objc func outgoButtonPressed(sender: UIButton) {
        self.onOutgoPressed?()
        hide()
    }

    @objc func transferButtonPressed(sender: UIButton) {
        self.onTransferPressed?()
        hide()
    }
    
    @objc func handleOutsideTap(sender: UITapGestureRecognizer? = nil) {
        hide()
    }
}
