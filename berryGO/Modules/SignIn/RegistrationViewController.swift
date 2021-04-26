//
//  RegistrationViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 24.02.2020.
//  Copyright © 2020 DATA5 CORP. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var firstNameTextField: BGTextField!
    @IBOutlet weak var lastNameTextField: BGTextField!
    @IBOutlet weak var emailTextField: BGTextField!
    @IBOutlet weak var passwordTextField: BGTextField!
    @IBOutlet weak var confirmPasswordTextField: BGTextField!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var createAccountButton: BGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        createAccountButton.layer.cornerRadius = 24
//        navigationController!.presentationController!.presentedView!.gestureRecognizers![0].isEnabled = false
//        scrollView.panGestureRecognizer.shouldRequireFailure(of: gs)
//        scrollView.panGestureRecognizer.require(toFail: gs)
//        gs.shouldRequireFailure(of: scrollView.panGestureRecognizer)
//        gs.require(toFail: scrollView.panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let info = sender.userInfo else { return }
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let bottomSafeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        if let scrollViewBottomConstraint = scrollViewBottomConstraint {
            scrollViewBottomConstraint.constant = keyboardHeight - bottomSafeAreaHeight
        }
        
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if let scrollViewBottomConstraint = scrollViewBottomConstraint {
            scrollViewBottomConstraint.constant = 0
        }
        view.layoutIfNeeded()
    }
    
    @objc func textFieldDidChange(_ notification: NSNotification) {
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
    }
}
//
//extension RegistrationViewController: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        isModalInPresentation = true
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        isModalInPresentation = false
//    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
//}

//class TestScrollView: UIScrollView {
//    gestureRec
//}
