import ARKit
extension SCNVector3{
    static func positionTranform(_ tranform:matrix_float4x4) -> SCNVector3{

        // Coordinates (x,y,z)
        return SCNVector3Make(tranform.columns.3.x, tranform.columns.3.y, tranform.columns.3.z)
    }

}

extension SCNVector3: Equatable {//Equatable Protocol

    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        // The left side is equal to the right side
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

