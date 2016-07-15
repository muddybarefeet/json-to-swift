//
//  hearthstone.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForHearthstoneJSON = NSBundle.mainBundle().pathForResource("hearthstone", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawHearthstoneJSON = NSData(contentsOfFile: pathForHearthstoneJSON!)

/* Error object */
var parsingHearthstoneError: NSError? = nil

/* Parse the data into usable form */
var parsedHearthstoneJSON = try! NSJSONSerialization.JSONObjectWithData(rawHearthstoneJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    
//    how many minions hava cost of 5?
//    how many weapons have a durability of 2
//    how many have a Battlecry effect mentioned in text
//    what is the average cost of Common minions (round to nearest hundredths)
//    what is the average stats-to-cost-ratio for all minions with a nonzero cost (narest hundredths -- attck+heath/cost)
    var countCost: Int = 0
    var durabilityCount: Int = 0
    var battlecryCount: Int = 0
    var commonTotal: Int = 0
    var costSum: Int = 0
    var statsCount: Double = 0
    var costNonZero: Int = 0
    
//    the contents of the basic key
    guard let arrayOfBasicDictionaries = parsedHearthstoneJSON["Basic"] as? [[String: AnyObject]] else {
        print("no key basic")
        return
    }
    
    for item in arrayOfBasicDictionaries{
        
        guard let cardType = item["type"] as? String else {
            print("no card type")
            return
        }
        
        if cardType == "Minion" {
            
            guard let minionCost = item["cost"] as? Int else {
                print("no cost key")
                return
            }
            if let minionText = item["text"] as? String where minionText.rangeOfString("Battlecry") != nil {
                print("has effect")
                battlecryCount += 1
            }
            guard let itemRarity = item["rarity"] as? String else {
                print("no rarity field")
                return
            }
            guard let minionAttack = item["attack"] as? Int else {
                print("Item attack not defined")
                return
            }
            guard let minionHealth = item["health"] as? Int else {
                print("Item health not defined")
                return
            }
            if minionCost == 5 {
                countCost += 1
            }

            if itemRarity == "Common" {
                commonTotal += 1
                costSum += minionCost
            }
            
            if minionCost != 0 {
                costNonZero += 1
                var stats = (Double(minionAttack) + Double(minionHealth))/Double(minionCost)
                statsCount += stats
            }

        }
        
        if cardType == "Weapon" {
            guard let weaponDurability = item["durability"] as? Int else {
                print("no durability field")
                return
            }
            if weaponDurability == 2 {
                durabilityCount += 1
            }
        }

    }
    
    print("There are \(countCost) minions with a cost of 5")
    print("The number of weapns with the durability count of 2 is \(durabilityCount)")
    print("There are \(battlecryCount) minions who have Battlecry mentioned in their text")
    print("The average cost of common minions is \(Float(costSum)/Float(commonTotal))")
    print("Stats to cost ratio \(Double(round(100*statsCount/Double(costNonZero))/100))")
    
    
}

parseJSONAsDictionary(parsedHearthstoneJSON)
