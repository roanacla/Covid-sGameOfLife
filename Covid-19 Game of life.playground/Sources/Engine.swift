////
////  Engine.swift
////  Assignment4
////
////  Created by Roger Navarro on 7/14/17.
////  Copyright © 2017 Harvard University. All rights reserved.
////
//
//import Foundation
//
//enum NotificationsNames:String {
//  case choosenGrid
//}
//
//enum NotificationUserInfo: String {
//  case didResetGrid = "didResetGrid"
//}
//
//public protocol EngineDelegate {
//  func engineDidUpdate(engine: EngineProtocol)
//}
//
//fileprivate let configurationsURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
//
//public protocol EngineProtocol {
//  var delegate: EngineDelegate? {get set}
//  var grid: GridProtocol {get}
//  var refreshRate: Double {get set}
//  var refreshTimer: Timer {get set}
//  var rows: Int {get set}
//  var cols: Int {get set}
//  init(rows: Int, cols: Int)
//  func step() -> GridProtocol
//}
//
//extension EngineProtocol {
//  var refreshRate: Double {
//    get {
//      return 0
//    }
//  }
//}
//
//public class StandardEngine: EngineProtocol {
//  public var delegate: EngineDelegate?
//  public var grid: GridProtocol {
//    didSet {
//      delegate?.engineDidUpdate(engine: self)
//      self.publish(grid:grid)
//      self.rows = grid.size.rows
//      self.cols = grid.size.cols
//      
//    }
//  }
//  public var refreshRate: Double
//  public var refreshTimer: Timer
//  public var rows: Int
//  public var cols: Int
//  public var didReset = false
//  public var configurationsList: [ConfigurationModel] = []
//  
//  static public var shared: StandardEngine = {
//    let standardEngine = StandardEngine(rows: 7, cols: 7)
//    return standardEngine
//  }()
//  
//  required public init(rows: Int, cols: Int) {
//    self.rows = rows
//    self.cols = cols
//    self.grid = Grid(self.rows, self.cols)
//    self.refreshTimer = Timer()
//    refreshRate = 0
//    let url = URL.init(string: configurationsURL)
////    self.loadJsonFile(url: url!) {list in
////      self.configurationsList = list
////    }
//  }
//  
//  public func step() -> GridProtocol {
//    grid = grid.next()
//    return grid
//  }
//  
//  func reset() -> GridProtocol {
//    didReset = true
//    grid = grid.reset()
//    return grid
//  }
//  
//  func startTimer(interval: Double, repeats: Bool) {
//    refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: { _ in
//      _ = self.step()
//    })
//  }
//  
//  func stopTimer() {
//    refreshTimer.invalidate()
//  }
//  
//  func publish(grid: GridProtocol) {
//    let notificationName = Notification.Name(Constants.gridObject)
//    var configurations: [String: Bool] = [:]
//    if didReset {
//      configurations[NotificationUserInfo.didResetGrid.rawValue] = true
//      didReset = false
//    }
//    NotificationCenter.default.post(name: notificationName,
//                                    object: grid,
//                                    userInfo: configurations)
//  }
//  
//
//}
