////
////  gridConfiguaration.swift
////  FinalProject
////
////  Created by Roger Navarro on 7/24/17.
////  Copyright © 2017 Harvard University. All rights reserved.
////
//
//import Foundation
//
//enum SerializationError: Error {
//  case missing(String)
//}
//
//public struct ConfigurationModel {
//  var title: String
//  var coordinates: [(Int, Int)]
//  var numberOfCols: Int = 0
//  var numberOfRows: Int = 0
//  
//  init(title: String, coordinates: [(Int, Int)], numberOfRows: Int, numberOfCols: Int) {
//    self.title = title
//    self.coordinates = coordinates
//    self.numberOfRows = numberOfRows
//    self.numberOfCols = numberOfCols
//  }
//  
//  init(title: String, coordinates: [(Int, Int)]) {
//    self.title = title
//    self.coordinates = coordinates
//    let size = self.recommendedSize()
//    self.numberOfRows = size.0
//    self.numberOfCols = size.1
//  }
//  
//  init?(json: [String: Any]) throws {
//    guard let title = json["title"] as? String else { throw SerializationError.missing("🔴 tittle")}
//    guard let contents = json["contents"] as? [Any] else {throw SerializationError.missing("🔴 contents")}
//    
//    var arrayOfCoordinates: [(Int, Int)] = []
//    for i in 0..<contents.count {
//      guard let coordinate = contents[i] as? [Any] else {throw SerializationError.missing("🔴 Error parsing content")}
//      let valueX = coordinate[0] as? Int
//      let valueY = coordinate[1] as? Int
//      guard let x = valueX, let y = valueY else { throw SerializationError.missing("🔴 coordinate 'x' or 'y' are not 'Int' values") }
//      arrayOfCoordinates.append((x, y))
//    }
//    
//    self.title = title
//    self.coordinates = arrayOfCoordinates
//    let size = self.recommendedSize()
//    self.numberOfRows = size.0
//    self.numberOfCols = size.1
//  }
//  
//  func gridInitializer(pos: (row: Int, col: Int)) -> CellState {
//    return self.coordinates.contains{$0.0 == pos.0 && $0.1 == pos.1} ? CellState.alive : CellState.empty
//  }
//  
//  func recommendedSize() -> (Int, Int) {
//    guard let maxRow = coordinates.max(by: {$0.0 < $1.0}) ,let maxCol  = coordinates.max(by: {$0.1 < $1.1}) else { return (10,10) }
//
//    return (maxRow.0 + 10, maxCol.1 + 10)
//  }
//}
