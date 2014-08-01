//
//  TipCalculator.swift
//  TipCalculator
//
//  Created by Juan Pedro Lozano on 31/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//

import Foundation

class TipCalculator {
    var total: Double
    var taxPct: Double
    var subtotal: Double {
        get {
        return total / (taxPct + 1)
        }
    }
    
    init(total:Double,taxPct:Double) {
        self.total = total //self distiguis properties from arguments
        self.taxPct = taxPct
    }
    
    func calcTipWithTipPct (#tipPct: Double) -> Double {
        return subtotal * tipPct
    }
    //Funcion devuelve diccionario
    
    func returnPossibleTips () -> [Int:Double] {
        let possibleTips = [0.15,0.18,0.20]
        var retVal = Dictionary<Int,Double>()
        for i in 0..<possibleTips.count {
            let incPct = Int(possibleTips[i] * 100)
            retVal[incPct] = calcTipWithTipPct(tipPct: possibleTips[i])
        }
        return retVal
    }
    
}
