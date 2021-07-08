//
//  ViewController.swift
//  UIElements
//
//  Created by Harbros47 on 20.01.21.
//

import UIKit
private enum Constants {
    static let text = """
            Создать контроллер, на котором сверху к низу расположены элементы: поиск, текст вью.
            В текст вью положить какой-нибудь длинный текст.
            В поиск вводим строку - начинаем искать совпадения по тексту.
            При этом, в конце ввода необходимо подсветить другим цветом совпавшие части из текста.
            """
    static let textButton = "Go to 2VC"
    static let widthButton: CGFloat = 70
    static let heightButton: CGFloat = 35
    static let divisibleByX: CGFloat = 1.2
    static let divisibleByY: CGFloat = 1.5
    static let additionalValueForY: CGFloat = 50
}

class ViewController: UIViewController, UISearchBarDelegate {
    
    private var textView = UITextView()
    private var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        createTextView()
        buttonGoTwoVC()
        registerForKeyboardNotifications()
        view.addTapGestureToHideKeyboard()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textView.attributedText =
            generateAttributedString(
                searchTerm: searchText,
                targetString: textView.text
            ) ?? NSAttributedString()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func createSearchBar() {
        searchBar.delegate = self
        let sizeSearchBar =  min(view.bounds.size.width, view.bounds.size.height)
        searchBar.frame = CGRect(
            x: view.bounds.size.width - sizeSearchBar,
            y: (view.bounds.size.width - sizeSearchBar) - Constants.additionalValueForY,
            width: min(view.bounds.size.width, view.bounds.size.height),
            height: min(view.bounds.size.width, view.bounds.size.height)
        )
        searchBar.showsCancelButton = true
        view.addSubview(searchBar)
    }
    
    private func buttonGoTwoVC() {
        let button = UIButton(
            frame: CGRect(
                x: view.center.x / Constants.divisibleByX,
                y: view.center.y * Constants.divisibleByY,
                width: Constants.widthButton,
                height: Constants.heightButton
            )
        )
        button.backgroundColor = .black
        button.setTitle(Constants.textButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func createTextView() {
        let  sizeTextView = min(view.bounds.size.width, view.bounds.size.height)
        textView = UITextView(
            frame: CGRect(
                x: view.bounds.size.width - sizeTextView,
                y: (view.bounds.size.height - sizeTextView) / Constants.divisibleByY,
                width: sizeTextView,
                height: sizeTextView / Constants.divisibleByY
            )
        )
        textView.text = Constants.text
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .systemGray
        view.addSubview(textView)
    }
    
    private func generateAttributedString(searchTerm: String, targetString: String) -> NSAttributedString? {
        let attribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
        let attributedString = NSMutableAttributedString(string: targetString, attributes: attribute)
        let coincidence = try? NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
        guard let coincidenceReturn = coincidence else { return attributedString }
        let range = NSRange(location: 0, length: targetString.count)
        for match in coincidenceReturn.matches(in: targetString, options: .withTransparentBounds, range: range) {
            attributedString.addAttribute(
                NSAttributedString.Key.backgroundColor,
                value: UIColor.green,
                range: match.range
            )
        }
        return attributedString
    }
    
    @objc private func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let size = kbFrameSize else { return }
        textView.contentInset.bottom = textView.frame.maxY - size.minY
    }
    
    @objc private func kbWillHide(_ notification: Notification) {
        textView.contentInset.bottom = .zero
    }
    
    @objc private func buttonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let informationController = storyboard.instantiateViewController(identifier: "InformationController")
        navigationController?.pushViewController(informationController, animated: true)
    }
    
    deinit {
        removeKeyboardNotification()
    }
}

extension UIView {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        addGestureRecognizer(tapGesture)
    }
}
