//
//  ViewController.swift
//  TipCalculator
//
//  Created by Juan Pedro Lozano on 31/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tipCalc = TipCalculator(total: 33.25, taxPct: 0.06)
    
    @IBOutlet var totalTextField:UITextField!
    @IBOutlet var taxPctSlider: UISlider!
    @IBOutlet var taxPctLabel: UILabel!
    @IBOutlet var resultsTextView: UITextView!
    
    @IBAction func calculateTapped(sender: AnyObject) {
        tipCalc.total = Double(totalTextField.text.bridgeToObjectiveC().doubleValue)
        let possibleTips = tipCalc.returnPossibleTips()
        var results = ""
        for (tipPct, tipValue) in possibleTips {
            results += "\(tipPct)%: \(tipValue)\n"
        }
        resultsTextView.text = results
    }
    
    @IBAction func taxPercentageChaged(sendr:AnyObject) {
        tipCalc.taxPct = Double(taxPctSlider.value) / 100
        refreshUI()
    }
    
    @IBAction func viewTapped(sender:AnyObject) {
        totalTextField.resignFirstResponder()
    }
    
    func refreshUI() {
        totalTextField.text = String(format: "%0.2f", tipCalc.total)
        taxPctSlider.value = Float(tipCalc.taxPct) * 100
        taxPctLabel.text = "Tax Percentaje \(Int(taxPctSlider.value))%"
        resultsTextView.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tip Calculator"
        refreshUI()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

