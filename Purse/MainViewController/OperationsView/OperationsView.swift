
import Foundation
import UIKit


public class OperationsView: UIView, UIGestureRecognizerDelegate {
    public var onIncomePress: (() -> ())?
    public var onOutcomePress: (() -> ())?
    public var onTransferPress: (() -> ())?
    public var onCancel: (() -> ())?

    var visualEffectView: UIVisualEffectView!
    var containerView: UIView!
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        self.addSubview(visualEffectView)

        let insideDistance = 25
        let buttonSize = 60
        let outsideDistance = (Int(UIScreen.main.bounds.width) - 3 * buttonSize - 4 * insideDistance) / 2

        containerView = UIView()
        visualEffectView.contentView.addSubview(containerView)

        containerView.frame = CGRect(x: Int(UIScreen.main.bounds.width) - buttonSize - 3 * outsideDistance, y: outsideDistance , width: buttonSize + 2 * insideDistance, height: buttonSize * 3 + insideDistance * 4)
        
        containerView.backgroundColor = UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 0.5)
        
        containerView.layer.cornerRadius = 35
        
        let incomeButton = UIButton(frame: CGRect(x: insideDistance, y: insideDistance, width: buttonSize, height: buttonSize))

        let outcomeButton = UIButton(frame: CGRect(x: insideDistance, y: 2 * insideDistance + buttonSize, width: buttonSize, height: buttonSize))

        let transferButton = UIButton(frame: CGRect(x: insideDistance, y: 3 * insideDistance + 2 * buttonSize, width: buttonSize, height: buttonSize))

        
        containerView.addSubview(incomeButton)
        containerView.addSubview(outcomeButton)
        containerView.addSubview(transferButton)

        
        initButton(incomeButton)
        incomeButton.setImage(UIImage(named: "1"), for: .normal) //

        initButton(outcomeButton)
        outcomeButton.setImage(UIImage(named: "1"), for: .normal) //

        initButton(transferButton)
        transferButton.setImage(UIImage(named: "1"), for: .normal) //


        incomeButton.addTarget(self, action: #selector(self.incomeButtonPress), for: .touchUpInside)
        outcomeButton.addTarget(self, action: #selector(self.outcomeButtonPress), for: .touchUpInside)
        transferButton.addTarget(self, action: #selector(self.transferButtonPress), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleOutsideTap))
        tap.delegate = self
        visualEffectView.addGestureRecognizer(tap)
        
    }
    
    func initButton(_ btn: UIButton) {
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
    
    public typealias VC = UIViewController & OperationsViewProtocol
    public func show(in vc: VC) {
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

        UIView.animate(withDuration: 0.3, animations:  {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: dx, y: dy).scaledBy(x: 0.1, y: 0.3)
        })
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { t in
            self.removeFromSuperview()
        }
    }
    
    
    @objc func incomeButtonPress(sender: UIButton) {
        self.onIncomePress?()
        hide()
    }
    
    
    @objc func outcomeButtonPress(sender: UIButton) {
        self.onOutcomePress?()
        hide()
    }

    @objc func transferButtonPress(sender: UIButton) {
        self.onTransferPress?()
        hide()
    }
    
    @objc func handleOutsideTap(sender: UITapGestureRecognizer? = nil) {
        self.onCancel?()
        hide()
    }
    
}
