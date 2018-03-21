import UIKit
import TinyConstraints
import SceneKit
import Observable

class LevelViewController: UIViewController {
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private var disposal = Disposal()
    private lazy var levelScene = LevelScene(level: level)
    private lazy var controller = iOSController()
    
    private lazy var scnView: SCNView = {
        let view = SCNView(frame: UIScreen.main.bounds)
        view.antialiasingMode = .multisampling4X
        view.scene = levelScene
        view.autoenablesDefaultLighting = true
        
        return view
    }()
    
    var level: Level {
        didSet {
            levelScene.level = level
        }
    }
    
    required init(level: Level) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        view.addGestureRecognizer(controller.panGestureRecognizer)
        
        view.addSubview(scnView)
        view.addSubview(backButton)
        
        backButton.topToSuperview(offset: 20, usingSafeArea: true)
        backButton.leftToSuperview(offset: 20)
        backButton.size(CGSize(width: 44, height: 44))
        
        controller.currentRotation.observe { [weak self] rotation, previousRotation in
            self?.levelScene.playerNode.currentRotation.value = rotation
            }.add(to: &disposal)
        
        
        
        let level = Level(index: GameIndex(world: 0, level: 0), size: .zero, start: .zero, end: .zero, walls: [
            Float2(1, 0),
            Float2(2, 0),
            Float2(3, 0),
            ], coins: [], spheres: [], lasers: [
                Laser(timeIntervals: [], startPosition: Float2(0, 1), vector: Float2(0, 3)),
                Laser(timeIntervals: [], startPosition: Float2(1, 0), vector: Float2(0, -4)),
                Laser(timeIntervals: [], startPosition: Float2(0, -1), vector: Float2(-5, 0)),
            ])
        
        levelScene.level = level
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func back(_ buttone: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}