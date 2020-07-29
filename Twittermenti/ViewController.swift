//
//  ViewController.swift
//  Twittermenti
//
//  Created by Himanshu Gupta on 23/07/2020.
//  Copyright © 2020 mine. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    let tweetCount = 100
    let swifter = Swifter(consumerKey: "enter your consumer key", consumerSecret: "enter your consumer secret key")
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
    }
    
    func fetchTweets(){
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText,lang : "en", count : tweetCount, tweetMode: .extended, success: { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string{
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
               
                self.predict(withTweets: tweets)
                
            }) { (error) in
                print("There was an error with the twitter api request \(error)")
            }
            
        }
    }
    
    func predict(withTweets tweets : [TweetSentimentClassifierInput]){
        do{
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for prediction in predictions {
                
                if prediction.label == "Pos"{
                    sentimentScore += 1
                }else if prediction.label == "Neg"{
                    sentimentScore -= 1
                }
                
                updateUI(withSentimentScore: sentimentScore)
            }
            
            
        }catch{
            print("There was an error making the prediction \(error)")
        }
    }
    
    func updateUI(withSentimentScore sentimentScore: Int){
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        }else if sentimentScore > 10{
            self.sentimentLabel.text = "😘"
        }else if sentimentScore > 0{
            self.sentimentLabel.text = "😙"
        }else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        }else if sentimentScore > -10{
            self.sentimentLabel.text = "😖"
        }else if sentimentScore > -20{
            self.sentimentLabel.text = "😢"
        }else {
            self.sentimentLabel.text = "😭"
        }
    }
}

