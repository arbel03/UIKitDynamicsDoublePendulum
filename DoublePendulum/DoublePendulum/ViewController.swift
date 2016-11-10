//
//  ViewController.swift
//  DoublePendulum
//
//  Created by Arbel Israeli on 10/11/2016.
//  Copyright © 2016 arbel03. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mass2: UIView!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    
    let mass1m: CGFloat = 30
    let mass2m: CGFloat = 25
    let length1: CGFloat = 100
    let length2: CGFloat = 100
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rod1 = UIView(frame: CGRect(x: 50, y: 50, width: 3, height: length1))
        rod1.backgroundColor = UIColor.black
        let rod2 = UIView(frame: CGRect(x: 100, y: 100, width: 3, height: length2))
        rod2.backgroundColor = UIColor.black
        
        let mass1 = UIView(frame: CGRect(x: 200, y: 200, width: mass1m, height: mass1m))
        mass1.backgroundColor = UIColor.red
        mass2 = UIView(frame: CGRect(x: 250, y: 250, width: mass2m, height: mass2m))
        mass2.backgroundColor = UIColor.blue
        mass1.layer.cornerRadius = mass1m/2
        mass2.layer.cornerRadius = mass2m/2
        
        mass2.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestRecognizer(sender:))))
        
        let anchorView = UIView(frame: CGRect(x: view.center.x-5, y: view.center.y-5, width: 10, height: 10))
        anchorView.backgroundColor = UIColor.black
        anchorView.layer.cornerRadius = 5
        view.addSubview(anchorView)
        
        //adding views
        view.addSubview(rod1)
        view.addSubview(rod2)
        view.addSubview(mass1)
        view.addSubview(mass2)
        
        animator = UIDynamicAnimator(referenceView: view)
        
        //Adding gravity
        gravity = UIGravityBehavior(items: [rod1, rod2, mass1, mass2])
        animator.addBehavior(gravity)
        
        //Attach rod1 to center
        let attachFirstRod = UIAttachmentBehavior(item: rod1, offsetFromCenter: UIOffset(horizontal: 0, vertical: -rod1.bounds.height/2), attachedToAnchor: anchorView.center)
        attachFirstRod.length = 3
        animator.addBehavior(attachFirstRod)
        
        //Attach rod1 to mass1
        let attachFirstMass = UIAttachmentBehavior(item: mass1, offsetFromCenter: UIOffset(horizontal: 0, vertical: 0), attachedTo: rod1, offsetFromCenter: UIOffset(horizontal: 0, vertical: rod1.bounds.height/2))
        attachFirstMass.length = 3
        animator.addBehavior(attachFirstMass)
        
        //Attach mass1 to rod2
        let attachSecondRod = UIAttachmentBehavior(item: rod2, offsetFromCenter: UIOffset(horizontal: 0, vertical: -rod2.bounds.height/2), attachedTo: mass1, offsetFromCenter: UIOffset(horizontal: 0, vertical: 0))
        attachSecondRod.length = 3
        animator.addBehavior(attachSecondRod)
        
        //Attach mass2 to rod2
        let attachSecondMass = UIAttachmentBehavior(item: mass2, offsetFromCenter: UIOffset(horizontal: 0, vertical: 0), attachedTo: rod2, offsetFromCenter: UIOffset(horizontal: 0, vertical: rod2.bounds.height/2))
        attachSecondMass.length = 3
        animator.addBehavior(attachSecondMass)
    }
    
    func gestRecognizer(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            animator.removeBehavior(gravity)
        case .changed:
            let x = sender.location(in: view).x
            let y = sender.location(in: view).y
            if pow((x-view.center.x), 2) + pow((y-view.center.y), 2) < pow(380, 2) {
                mass2.center = sender.location(in: view)
                animator.updateItem(usingCurrentState: mass2)
            }
        case .ended:
            animator.addBehavior(gravity)
        default:
            print("default")
            break
        }
    }

}

