//
//  achievements.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAchievementsJSON = NSBundle.mainBundle().pathForResource("achievements", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAchievementsJSON = NSData(contentsOfFile: pathForAchievementsJSON!)

/* Error object */
var parsingAchivementsError: NSError? = nil

/* Parse the data into usable form */
var parsedAchievementsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAchievementsJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    
//    how many achievements have a point value greater than 10
//    what is the average point value for achievements
//    what mission must you complete to get the cool running achievement
//    how many achievements belong to matchmaking category
    
    var pointsCount: Int = 0
    var sumAchievements: Int = 0
    var totalPoints: Int = 0
    
    var matchmakingAchievementCount = 0
    var categoryCounts: [Int: Int] = [:]
    
//    get the two top level keys in the json
    guard let achievementsArray = parsedAchievementsJSON["achievements"] as? [[String: AnyObject]] else {
        print("bad")
        return
    }
    
    guard let categoryDictionaries = parsedAchievementsJSON["categories"] as? [NSDictionary] else {
        print("Cannot find key 'categories' in \(parsedAchievementsJSON)")
        return
    }
    
    /* Create array to hold the categoryIds for "Matchmaking" categories */
    var matchmakingIds: [Int] = []
    
    /* Store all "Matchmaking" categories */
    for categoryDictionary in categoryDictionaries {
        
        if let title = categoryDictionary["title"] as? String where title == "Matchmaking" {
            
            guard let children = categoryDictionary["children"] as? [NSDictionary] else {
                print("Cannot find key 'children' in \(categoryDictionary)")
                return
            }
            
            for child in children {
                guard let categoryId = child["categoryId"] as? Int else {
                    print("Cannot find key 'categoryId' in \(child)")
                    return
                }
                matchmakingIds.append(categoryId)
            }
        }
    }
    
    print(matchmakingIds.count)
    
    for item in achievementsArray {
        
        guard let points = item["points"] as? Int else {
            print("points not a key")
            return
        }
        
        guard let categoryId = item["categoryId"] as? Int else {
            print("no cat id")
            return
        }
        
        /* Does category have a key in dictionary? If not, initialize */
        if categoryCounts[categoryId] == nil {
            categoryCounts[categoryId] = 0
        }
        
        /* Add one to category count */
        if let currentCount = categoryCounts[categoryId] {
            categoryCounts[categoryId] = currentCount + 1
        }
        
        if points > 10 {
            pointsCount += 1
        }
        
        //        average points count
        sumAchievements += points
        
    }

    
    /* Calculate number of "Matchmaking" achievements */
    for matchmakingId in matchmakingIds {
        if let categoryCount = categoryCounts[matchmakingId] {
            matchmakingAchievementCount += categoryCount
        }
    }
    
    print("There are \(pointsCount) achievements with point counts over 10")
    print("The average points count is \(Double(sumAchievements)/Double(achievementsArray.count)) ")
    print("\(matchmakingAchievementCount) achievements belong to the matchmaking achievements")
    
    
}

parseJSONAsDictionary(parsedAchievementsJSON)
