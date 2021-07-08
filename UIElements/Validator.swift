//
//  Validator.swift
//  UIElements
//
//  Created by Harbros47 on 2.02.21.
//

import Foundation

class Validation {
    public func validateName(name: String) -> Bool {
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    public func validatePhoneNumber(phoneNumber: String) -> Bool {
        let phoneNumberRegex = "(\\+\\d{3}\\s*(\\(\\d{2}\\)))?\\s*\\d{3}\\-?\\d{2}-?\\d{2}"
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    public func validateDateOfBirth(dateOfBirth: String) -> Bool {
        let dateOfBirthRegex = "\\d{2}\\.\\d{2}\\.\\d{4}"
        let trimmedString = dateOfBirth.trimmingCharacters(in: .whitespaces)
        let validateDateOfBirth = NSPredicate(format: "SELF MATCHES %@", dateOfBirthRegex)
        let isValidDateOfBirth = validateDateOfBirth.evaluate(with: trimmedString)
        return isValidDateOfBirth
    }
    public func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    
    public func validateAddress(addressField: String) -> Bool {
        let addressRegexString = "[А-Я0-9а-я.,:; ]{2,64}"
        let trimmedString = addressField.trimmingCharacters(in: .whitespaces)
        let validateAddressString = NSPredicate(format: "SELF MATCHES %@", addressRegexString)
        let isValidateAddressString = validateAddressString.evaluate(with: trimmedString)
        return isValidateAddressString
    }
}
