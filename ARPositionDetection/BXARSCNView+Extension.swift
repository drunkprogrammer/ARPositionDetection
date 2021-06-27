import ARKit
extension ARSCNView{
    // Get three-dimensional coordinates
    // The parameter is a point -> returns a three-dimensional coordinate
    func worldVector(for position:CGPoint) ->SCNVector3?{
        
        //result
        let results = hitTest(position, types: [.featurePoint])
        
        //The distance between the camera and the object is used to search for the anchor points detected by ARSession, as well as real-world objects instead of the content in SceneKit in the view.
        guard let result = results.first else {
            return nil
        }
        
        //Return the position of the camera
        return SCNVector3.positionTranform(result.worldTransform)
        
    }
    
    
    
}
