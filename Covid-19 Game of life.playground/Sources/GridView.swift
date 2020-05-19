//
//  GridView.swift
//  Assignment3
//
//  Created by Roger Navarro on 7/4/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//
import UIKit

public protocol GridViewDelegate {
  func gridView(didUpdate grid: GridProtocol)
}

@IBDesignable
public class GridView: UIView {
  
  //MARK: - IBInspectables
  
  @IBInspectable var rows: Int = 20 {
    didSet {
      if rows != oldValue { removeTouchableView() }
    }
  }
  @IBInspectable var cols: Int = 20 {
    didSet {
      if cols != oldValue { removeTouchableView() }
    }
  }
  @IBInspectable public var livingColor: UIColor = UIColor.black
  @IBInspectable public var emptyColor: UIColor = UIColor.clear
  @IBInspectable public var bornColor: UIColor = UIColor.darkGray
  @IBInspectable public var diedColor: UIColor = UIColor.lightGray
  @IBInspectable public var gridColor: UIColor = UIColor.black
  @IBInspectable public var gridWidth: CGFloat = 0.0
  
  //MARK: - Properties
  public var grid: GridProtocol? {
    didSet {
      guard let grid = self.grid else { return }
      self.rows = grid.size.rows
      self.cols = grid.size.cols
      redraw()
    }
  }
  
  var touchesInCordinates: [(row: Int, col: Int)] = []
  var startTouches: Bool = false {
    didSet {
      if startTouches == false {
        touchesInCordinates = []
      }
    }
  }
  public var delegate: GridViewDelegate?
  public var backColor: UIColor = UIColor.white {
    didSet{
      setBackGroundColor(color: backColor)
    }
  }
  
  //MARK: - Computed Properties
  
  var sizeDeterminant: Int {
    return (rows >= cols) ? rows : cols
  }
  var cellSize: CGFloat {
    return self.bounds.width / CGFloat(sizeDeterminant)
  }
  
  private var touchableView: UIView? {
    guard let view = self.viewWithTag(1000) else { return nil }
    return view
  }
  
  //MARK: - View Life Cycle
  override public func draw(_ rect: CGRect) {
    drawGrid()
  }
  
  func redraw() {
    setNeedsDisplay()
  }
  
  private func drawGrid() {
    let longestSize = (rows >= cols) ? cellSize * CGFloat(rows) : cellSize * CGFloat(cols)
    let shortestSize = (rows >= cols) ? cellSize * CGFloat(cols) : cellSize * CGFloat(rows)
    let shortSizeStart = (longestSize - shortestSize) / 2
    let shortSizeEnd = shortSizeStart + shortestSize
    let longSizeStart = CGFloat(0)
    let longSizeEnd = longestSize
    let startForRows = (rows >= cols) ? shortSizeStart : longSizeStart
    let endForRows = (rows >= cols) ? shortSizeEnd : longSizeEnd
    let startForCols = (rows >= cols) ? longSizeStart : shortSizeStart
    let endForCols = (rows >= cols) ? longSizeEnd : shortSizeEnd
    
    //Nested Function Level 1
    func drawLines() {
      
      //Nested Function Level 2
      func drawLineFrom(point start : CGPoint, toPoint end:CGPoint) {
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = gridWidth
        gridColor.setStroke()
        path.stroke()
        
      }
      
      //Nested Function Level 1 - Code
      for i in 0...rows {
        let variant = cellSize * CGFloat(i) + startForCols
        let pointLeft = CGPoint(x: startForRows, y: variant )
        let pointRight = CGPoint(x: endForRows, y: variant)
        drawLineFrom(point: pointLeft, toPoint: pointRight)
      }
      
      for i in 0...cols {
        let variant = cellSize * CGFloat(i) + startForRows
        let pointTop = CGPoint(x: variant, y: startForCols)
        let pointBottom = CGPoint(x: variant, y: endForCols)
        drawLineFrom(point: pointTop, toPoint: pointBottom)
      }
      
    }
    
    //Nested Function Level 1
    func drawCircles() {
      
      //Nested Function Level 2
      func getTheCenterPointOfCellIn(row: Int, col: Int) -> CGPoint {
        let variantX = cellSize * CGFloat(col) + startForRows
        let variantY = cellSize * CGFloat(row) + startForCols
        let x = cellSize / CGFloat(2) + variantX
        let y = cellSize / CGFloat(2) + variantY
        return CGPoint.init(x: x, y: y)
      }
      
      //Nested Function Level 2
      func getCircleColor(row: Int, col: Int) -> UIColor{
        guard let grid = self.grid else {
          return emptyColor
        }
        switch grid[row,col] {
        case .alive:
          return livingColor
        case . empty:
          return emptyColor
        case .born:
          return bornColor
        case .died:
          return diedColor
        }
      }
      
      //Nested Function Level 2
      func drawCircleIfNeededIn(point center: CGPoint,
                                withColor color: UIColor){
        let radius = (cellSize /  CGFloat(2)) * CGFloat(0.8)
        let circlePath = UIBezierPath(arcCenter: center, radius: radius,
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(Double.pi * 2),
                                      clockwise: true)
        color.setStroke()
        circlePath.stroke()
        color.setFill()
        circlePath.fill()
      }
      //Nested Function Level 1 - Code
      for row in 0..<rows {
        for col in 0..<cols  {
          let centerPoint = getTheCenterPointOfCellIn(row: row, col: col)
          let color = getCircleColor(row: row, col: col)
          drawCircleIfNeededIn(point: centerPoint,
                               withColor: color)
        }
      }
    }
    
    //Nested Function Level 1
    func drawTouchablePart() { //This method adds inside the grid another view to support touches when the grid doesn't have the same number of columns and rows. 
      if self.viewWithTag(1000) == nil {
        let frame = (rows >= cols) ? CGRect(x: shortSizeStart, y: longSizeStart, width: shortestSize, height: longestSize) : CGRect(x: longSizeStart, y: shortSizeStart, width: longestSize, height: shortestSize)
        let view = UIView(frame: frame)
        view.tag = 1000
        self.addSubview(view)
      }
    }
    //Function Actions
    drawLines()
    drawCircles()
    drawTouchablePart()
  }
  
  //MARK: - Touch Events
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    startTouches = true
    touchesHandler(touches: touches)
  }
  
  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchesHandler(touches: touches)
  }
  
  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let grid = self.grid else {return}
    startTouches = false
    delegate?.gridView(didUpdate: grid)
  }
  
  //MARK: - Other functions
  private func touchesHandler(touches: Set<UITouch>) {
    guard let touchableView = self.touchableView else { return }
    let point = touches.first!.location(in: touchableView)
    guard let coordinate = cellCoordinatesFor(pointInView: point) else { return }
    if !touchesInCordinates.contains(where: {$0.row == coordinate.row && $0.col == coordinate.col}) {
      touchesInCordinates.append(coordinate)
      tappedAt(row: coordinate.row, col: coordinate.col)
    }
  }
  
  private func cellCoordinatesFor(pointInView point: CGPoint) -> (col: Int, row: Int)? {
    guard let touchablePart = self.viewWithTag(1000) else { return nil }
    guard point.x >= 0, point.y >= 0, point.x <= touchablePart.frame.width, point.y <= touchablePart.frame.height else { return nil }
    let dividerX = touchablePart.frame.width / CGFloat(cols)
    let dividerY = touchablePart.frame.height / CGFloat(rows)
    let x = Int(point.x / dividerX)
    let y = Int(point.y / dividerY)
    return (col: x, row: y)
  }
  
  func tappedAt(row: Int, col: Int) {
    self.grid?[row, col].toggle()
  }
  
  func removeTouchableView() {
      let view = touchableView
      view?.removeFromSuperview()
  }
  
  func setBackGroundColor(color: UIColor) {
    self.backgroundColor = color
  }
} 
