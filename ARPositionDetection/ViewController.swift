import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController{
    @IBOutlet weak var sceneV: ARSCNView!
    @IBOutlet weak var targetIM: UIImageView!
    
    var session = ARSession()
    var configuration = ARWorldTrackingConfiguration()
    var isMeasuring = false //The default state is non-measurement state
    
    var vectorZero = SCNVector3(0, 0, 0) // 0,0,0
    var vectorStart = SCNVector3()
    var vectorEnd = SCNVector3()
    
    var xLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.blue
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.frame = CGRect(x: 30, y:60, width: 600, height:30)
        return label
    }()
        
    var yLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.green
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.frame = CGRect(x: 30, y: 90, width: 600, height:30)
        return label
    }()
    
    var zLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.yellow
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.frame = CGRect(x: 30, y: 120, width: 600, height:30)
        return label
    }()
    
    let cameraRelativePosition = SCNVector3(0,1,0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.run(configuration, options:[.resetTracking,.removeExistingAnchors])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.pause()
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUp()
    }
       
    func setUp()  {
    //mediate synchronization of the view's AR scene information with SceneKit content
        sceneV.delegate = self
        sceneV.session = session
        sceneV.showsStatistics = true
        targetIM.image = UIImage(named: "GreenTarget")
    }

    func reset(){
        isMeasuring = true
        vectorStart = SCNVector3()
        vectorEnd = SCNVector3()
    }
       
    func scanWorld(){
        
        //camera position
        guard let worldPosition = sceneV.worldVector(for: view.center) else {
            return
        }
        
        if isMeasuring {
            
            // start point
            if  vectorStart == vectorZero {
                vectorStart = worldPosition //Set the current position as the start position
            }
            
            // end point
            vectorEnd = worldPosition
            
        guard let CurrentFrame = session.currentFrame else{
            return
        }
            
        let position = CurrentFrame.camera.transform.columns.3
            
        let xPosition = position.x.description
        let yPosition = position.y.description
        let zPosition = position.z.description
           
        xLabel.text = "X: " + xPosition + "m"
        yLabel.text = "Y: " + yPosition + "m"
        zLabel.text = "Z: " + zPosition + "m"
        
        view.addSubview(xLabel)
        view.addSubview(yLabel)
        view.addSubview(zLabel)
            
        }
        
    }
    
    @IBAction func UnitClick(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tap the screen to start the test
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMeasuring {
            reset()
            isMeasuring = true
            targetIM.image = UIImage(named: "WhiteTarget")
        }else{
            isMeasuring = false
            targetIM.image = UIImage(named: "GreenTarget")
        }
    }
   
}
extension ViewController: ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.scanWorld()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {

    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        

    }
}
