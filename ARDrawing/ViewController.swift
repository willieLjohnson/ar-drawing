//
//  ViewController.swift
//  ARDrawing
//
//  Created by Willie Johnson on 9/27/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
  @IBOutlet weak var sceneView: ARSCNView!
  
  @IBOutlet weak var draw: UIButton!
  
  let configuration = ARWorldTrackingConfiguration()

  override func viewDidLoad() {
    super.viewDidLoad()
    sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    sceneView.showsStatistics = true
    sceneView.session.run(configuration)
    sceneView.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
    guard let pointOfView = sceneView.pointOfView else { return }
    let transform = pointOfView.transform
    let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
    let location = SCNVector3(transform.m41, transform.m42, transform.m43)
    let currentPositionOfCamera = orientation + location

    print(currentPositionOfCamera)
    DispatchQueue.main.async {
      if self.draw.isHighlighted {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        sphereNode.position = currentPositionOfCamera
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red

        print("draw")
      } else {
        let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.005))
        pointer.position = currentPositionOfCamera
        pointer.name = "pointer"

        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
          if node.name == "pointer" {
            node.removeFromParentNode()
          }
        }

        self.sceneView.scene.rootNode.addChildNode(pointer)
        pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
      }
    }
  }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
