import Cocoa
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/base/Desktop/twitter-sanders-apple3.csv"))
let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 55)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let evaluationMetrics = sentimentClassifier.evaluation(on: trainingData, textColumn: "text", labelColumn: "class")

let evaluationAcurracy = (1.0 - evaluationMetrics.classificationError) * 100
print(evaluationMetrics)

let metaData = MLModelMetadata(author : "Himanshu Gupta", shortDescription:"a model trained to classify sentiments based on tweets" , version : "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/base/Desktop/TweetSentimentClassifier.mlmodel"))

try sentimentClassifier.prediction(from: "@Apple is a terrible company!")

try sentimentClassifier.prediction(from: "I just found the company with worst ways to exploit customers and it's @duckandwaffle")

try sentimentClassifier.prediction(from: "@cocacola ads are the best of the worst")
