//
//  InformationViewController.swift
//  UIElements
//
//  Created by Harbros47 on 22.01.21.
//

import UIKit
private enum Constants {
    static let maxNumberCount = 12
    static let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    static let errorLabelText = "имя отсутсвует"
    static let errorLastNameText = "фамилия отсутсвует"
    static let errorDateOfBirthText = "дата рождения отсутсвует"
    static let errorEMailText = "e-Mail отсутсвует"
    static let errorTheAddressText = "адрес отсутсвует"
    static let errorNumberText = "номер отсутсвует"
    static let textButton = "Enter"
    static let buttonSize: CGFloat = 50
}

class InformationController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var lastNameField: UITextField!
    @IBOutlet weak private var dateOfBirthField: UITextField!
    @IBOutlet weak private var eMailField: UITextField!
    @IBOutlet weak private var theAddressField: UITextField!
    @IBOutlet weak private var numberField: UITextField!
    private var validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addTapGestureToHideKeyboard()
    }
    
    // MARK: - функция, которая спрашивает делегата, обрабатывать ли нажатие кнопки возврата для текстового поля.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            lastNameField.becomeFirstResponder()
        case lastNameField:
            dateOfBirthField.becomeFirstResponder()
        case dateOfBirthField:
            eMailField.becomeFirstResponder()
        case eMailField:
            theAddressField.becomeFirstResponder()
        case theAddressField:
            numberField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    private func createAlert(message: String) {
        let alert = UIAlertController(
            title: "Warning!",
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func goToNextController() {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let informationController = storyboard
            .instantiateViewController(identifier: "QuestionnaireController") as QuestionnaireController
        informationController.informationPerson = PersonInformation(
            labelText: nameField.text ?? Constants.errorLabelText,
            lastNameText: lastNameField.text ?? Constants.errorLabelText,
            dateOfBirthText: dateOfBirthField.text ?? Constants.errorDateOfBirthText,
            eMailText: eMailField.text ?? Constants.errorEMailText,
            theAddressText: theAddressField.text ?? Constants.errorTheAddressText,
            numberText: numberField.text ?? Constants.errorNumberText
        )
        navigationController?.pushViewController(informationController, animated: true)
    }
    
    private func crateValidate(message: String, expression: Bool) -> Bool {
        let isValidate = expression
        if !isValidate {
            createAlert(message: message)
            return true
        }
        return isValidate
    }
    
    // MARK: - кнопка, которая скрывает клавиатуру
    @IBAction private func enter(_ sender: Any) {
        guard let name = nameField.text, let lastName = lastNameField.text, let email = eMailField.text,
              let dateOfBirth = dateOfBirthField.text, let address = theAddressField.text,
              let phone = numberField.text else { return }
        
        let validateName = crateValidate(
            message: "Please enter your name",
            expression: validation.validateName(name: name)
        )
        let validateLastName = crateValidate(
            message: "Please enter your last name",
            expression: validation.validateName(name: lastName)
        )
        let validateEmail = crateValidate(
            message: "Please enter your date of birth",
            expression: validation.validateDateOfBirth(dateOfBirth: dateOfBirth)
        )
        let validateDateOfBirth = crateValidate(
            message: "Please enter your Email",
            expression: validation.validateEmailId(emailID: email)
        )
        let validateAddress = crateValidate(
            message: "Please enter your Address",
            expression: validation.validateAddress(addressField: address)
        )
        let validatePhone = crateValidate(
            message: "Please enter your number phone",
            expression: validation.validatePhoneNumber(phoneNumber: phone)
        )
        
        if validateName || validateLastName || validateEmail ||
            validateDateOfBirth || validateAddress || validatePhone {
            goToNextController()
        }
    }
    
    // MARK: - формат ввода номера телефона +ХXX (XX) XXX-XX-XX
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = Constants.regex.stringByReplacingMatches(
            in: phoneNumber,
            options: [],
            range: range,
            withTemplate: ""
        )
        
        if number.count > Constants.maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: Constants.maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(
                of: pattern,
                with: "$1 ($2) $3",
                options: .regularExpression,
                range: regRange
            )
        } else {
            let pattern = "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(
                of: pattern,
                with: "$1 ($2) $3-$4-$5",
                options: .regularExpression,
                range: regRange
            )
        }
        return "+" + number
    }
}

extension InformationController {
    // MARK: - метод делегата, который будет вызываться при добавлении или удалении цифр
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard textField.isEqual(numberField) else { return true }
        guard let text = textField.text else { return false }
        let fullString = text + string
        textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
    }
}
