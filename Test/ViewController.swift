//
//  ViewController.swift
//  Test
//
//  Created by COMATOKI on 2023-07-24.
//

import UIKit

class ViewController: UIViewController {

    let scrollerBackView = UIView()
    let scroller = UIView()
    let mainTitleLabel = UILabel()
    var gesture = UIPanGestureRecognizer()
    let shapeLayer: CAShapeLayer = CAShapeLayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScroller()
        setMainTitleLabel()
        addGesture()
        setCentreLine()
    }

    private func setScroller() {
        self.view.addSubview(scroller)
        scroller.frame = CGRect(x: self.view.center.x - 20, y: self.view.center.y, width: 100, height: 100)
        scroller.layer.cornerRadius = 50
        scroller.backgroundColor = .systemBlue
        
        scrollerBackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollerBackView)
        scrollerBackView.backgroundColor = .yellow
        scrollerBackView.widthAnchor.constraint(equalTo: scroller.widthAnchor, constant: 40).isActive = true
        scrollerBackView.heightAnchor.constraint(equalTo: scroller.heightAnchor, constant: 40).isActive = true
        scrollerBackView.centerXAnchor.constraint(equalTo: scroller.centerXAnchor).isActive = true
        scrollerBackView.centerYAnchor.constraint(equalTo: scroller.centerYAnchor).isActive = true
        scrollerBackView.layer.cornerRadius = 70
//        scrollerBackView.layer.addSublayer(getOutherGrayCircle())
        scrollerBackView.layer.borderWidth = 3
        scrollerBackView.layer.borderColor = UIColor.black.cgColor
        self.view.bringSubviewToFront(scroller)
        
    }
    
    func getOutherGrayCircle() -> CAShapeLayer {
//        let center = CGPoint(x: 0 , y: 30)
        let beizerPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 50, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        UIColor.black.setStroke()
        beizerPath.lineWidth = 10
        beizerPath.stroke()
        
        
        var lastArcAngle = -CGFloat.pi
            func addArc(color: UIColor, percentage: CGFloat) {
                let fullCircle = CGFloat.pi * 2
                let arcAngle = fullCircle * percentage
                let path = UIBezierPath(arcCenter: CGPoint(x: 100, y: 70), radius: 50, startAngle: lastArcAngle, endAngle: lastArcAngle + arcAngle, clockwise: true)
                color.setStroke()
                path.lineWidth = 10
                path.stroke()
                lastArcAngle += arcAngle
            }
            addArc(color: .red, percentage: 1.0 / 6.0)
            addArc(color: .green, percentage: 1.0 / 6.0)
            addArc(color: .blue, percentage: 1.0 / 6.0)
        let innerGrayCircle = CAShapeLayer()
        innerGrayCircle.path = beizerPath.cgPath
        innerGrayCircle.strokeColor = UIColor.black.cgColor
        
        return innerGrayCircle
    }
    
    private func setMainTitleLabel() {
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainTitleLabel)
        mainTitleLabel.leadingAnchor.constraint(equalTo: scroller.trailingAnchor, constant: 30).isActive = true
        mainTitleLabel.centerYAnchor.constraint(equalTo: scroller.centerYAnchor).isActive = true
        mainTitleLabel.widthAnchor.constraint(equalTo: scroller.widthAnchor).isActive = true
        mainTitleLabel.heightAnchor.constraint(equalTo: scroller.heightAnchor).isActive = true
        mainTitleLabel.text = "32"
        mainTitleLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
    }
    
    private func addGesture() {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(moveScroller))
        scroller.addGestureRecognizer(gesture)
        scroller.isUserInteractionEnabled = true
    }
    
    @objc func moveScroller(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("moving detected")
        self.view.bringSubviewToFront(scrollerBackView)
        self.view.bringSubviewToFront(scroller)
        let translation = gestureRecognizer.translation(in: self.view)
        
        scroller.center = CGPoint(x: scroller.center.x, y: scroller.center.y + translation.y)
        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    private func setCentreLine() {
        self.view.layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3.0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.view.bounds.midX, y: 0))
        path.addLine(to: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY))
        shapeLayer.path = path.cgPath
    }
}

