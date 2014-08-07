//
//  ViewController.swift
//  TipCalculator
//
//  Created by Juan Pedro Lozano on 31/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//

import UIKit


class ViewController: UIKit.UIViewController,UITableViewDataSource {

    let tipCalc = TipCalculatorModel(total: 0.00, taxPct: 0.06)
    var possibleTips = Dictionary<Int, (tipAmt:Double, total:Double)>()
    var sortedKeys:[Int] = []
    
    @IBOutlet var totalTextField:UITextField!
    @IBOutlet var taxPctSlider: UISlider!
    @IBOutlet var taxPctLabel: UILabel!
    @IBOutlet var resultsTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func calculateTapped(sender: AnyObject) {
        tipCalc.total = Double(totalTextField.text.bridgeToObjectiveC().doubleValue)
        possibleTips = tipCalc.returnPossibleTips()
        sortedKeys = sorted(Array(possibleTips.keys))
        tableView.reloadData()
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tip Calculator"
        refreshUI()
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        return sortedKeys.count
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!  {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        let tipPct = sortedKeys[indexPath.row]
        let tipAmt = possibleTips[tipPct]!.tipAmt
        let total = possibleTips[tipPct]!.total
        cell.textLabel.text = "\(tipPct)%:"
        cell.detailTextLabel.text = String(format:"Tip: $%0.2f, Total: $%0.2f", tipAmt, total)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

