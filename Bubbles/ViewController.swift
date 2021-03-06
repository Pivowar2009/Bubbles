//
//  ViewController.swift
//  Bubbles
//
//  Created by Nazar Prysiazhnyi on 10/23/18.
//  Copyright © 2018 Nazar Prysiazhnyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let cameraController = CameraController()
    
    private var arrayOfBalls: [Ball] = []
    private var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.configureCameraController()
            DispatchQueue.main.async {
                self.start()
            }
        }
    }
    
    private func start() {
        let displayLink = CADisplayLink(target: self, selector: #selector(moveBubble))
        displayLink.add(to: .main, forMode: .default)
    }
    
    private func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.view)
        }
    }
    
    @objc private func moveBubble() {
        seconds += 1
        let width = self.view.frame.width
        let height = self.view.frame.height
        if arrayOfBalls.count <= 100 && seconds % 30 == 0 {
            self.addBalls(amount: 5)
        }
        for i in arrayOfBalls {
            i.move()
            if i.startX <= 0 {
                i.dX = .Right
                i.ballColor = BallColor.Blue.introduce()
            } else if i.startX >= width {
                i.dX = .Left
                i.ballColor = BallColor.Green.introduce()
            }
            
            if i.startY >= height {
                i.dY = .Up
                i.ballColor = BallColor.Red.introduce()
            } else if i.startY <= 0 {
                i.dY = .Down
                i.ballColor = BallColor.Yellow.introduce()
            }
        }
    }
    
    private func addBalls(amount: Int) {
        for _ in 0...amount {
            let ball = Ball()
            let x =  Double(arc4random_uniform(UInt32(self.view.frame.maxX)))
            let y = Double(arc4random_uniform(UInt32(self.view.frame.maxY)))
            ball.created(startX: x, startY: y)
            self.view.layer.addSublayer(ball)
            arrayOfBalls.append(ball)
        }
    }
}

