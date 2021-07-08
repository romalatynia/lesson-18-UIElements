//
//  QuestionnaireController.swift
//  UIElements
//
//  Created by Harbros47 on 25.01.21.
//

import UIKit

class QuestionnaireController: UIViewController {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var lastNameLabel: UILabel!
    @IBOutlet weak private var dateOfBirthLabel: UILabel!
    @IBOutlet weak private var eMailLabel: UILabel!
    @IBOutlet weak private var theAddressLabel: UILabel!
    @IBOutlet weak private var numberLabel: UILabel!
    
    var informationPerson = PersonInformation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = informationPerson.labelText
        lastNameLabel.text = informationPerson.lastNameText
        dateOfBirthLabel.text = informationPerson.dateOfBirthText
        eMailLabel.text = informationPerson.eMailText
        theAddressLabel.text = informationPerson.theAddressText
        numberLabel.text = informationPerson.numberText
    }
}
