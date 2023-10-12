//
//  ViewController.swift
//  PicnicTable
//
//  Created by DS on 10/23/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var used = false
    var ship: SCNNode!

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
//        let scene = SCNScene(named: "art.scnassets/picnic_table2.dae")!
//        
//        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !used {
          // Called when any node has been added to the anchor
          guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
          DispatchQueue.main.async {
              self.infoLabel.text = "Surface Detected."
          }
          
          let shipScn = SCNScene(named: "picnic_table2.dae", inDirectory: "art.scnassets")
          ship = shipScn?.rootNode
          ship.simdPosition = float3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
          sceneView.scene.rootNode.addChildNode(ship)
          node.addChildNode(ship)
        used = true
        } else {
            
        }
      }
     
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            // This method will help when any node has been removed from sceneview
        }
     
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            // Called when any node has been updated with data from anchor
        }
    
    // MARK: - ARSessionObserver
     
        func sessionWasInterrupted(_ session: ARSession) {
            infoLabel.text = "Session was interrupted"
        }
     
        func sessionInterruptionEnded(_ session: ARSession) {
            infoLabel.text = "Session interruption ended"
            resetTracking()
        }
     
        func session(_ session: ARSession, didFailWithError error: Error) {
            infoLabel.text = "Session failed: \(error.localizedDescription)"
            resetTracking()
        }
     
         func resetTracking() {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
     
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            // help us inform the user when the app is ready
            switch camera.trackingState {
            case .normal :
                infoLabel.text = "Move the device to detect horizontal surfaces."
     
            case .notAvailable:
                infoLabel.text = "Tracking not available."
     
            case .limited(.excessiveMotion):
                infoLabel.text = "Tracking limited - Move the device more slowly."
     
            case .limited(.insufficientFeatures):
                infoLabel.text = "Tracking limited - Point the device at an area with visible surface detail."
     
            case .limited(.initializing):
                infoLabel.text = "Initializing AR session."
     
            default:
                infoLabel.text = ""
            }
        }
    
}
