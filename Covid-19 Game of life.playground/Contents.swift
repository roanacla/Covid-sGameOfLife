import UIKit
import PlaygroundSupport


var str = "Hello, playground"
let a = Grid.init(15,15)

class NewView: UIViewController {
    var gridView: GridView = GridView(frame: .zero)
    var nextButton: UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.grid = Grid.init(30, 30)
        self.view.backgroundColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        self.view.addSubview(gridView)
//        self.nextButton = UIButton()
        self.nextButton.titleLabel?.text = "Next Step"
        self.nextButton.backgroundColor = .green
        self.nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        self.view.addSubview(nextButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let x = view.frame.width/2 - 150
        let y = view.frame.height/2 - 150
        gridView.frame = CGRect(x: x, y: y, width: 300, height: 300)
        gridView.backgroundColor = UIColor.yellow
        self.nextButton.frame = CGRect(x: 5, y: 5, width: 100, height: 20)
    }
    
    @objc func nextStep() {
        gridView.grid = gridView.grid?.next()
    }
    
}

let newView = NewView()

PlaygroundPage.current.liveView = newView




