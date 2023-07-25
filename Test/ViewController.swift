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
    var lines: [UIView] = []
    var numbers: [UILabel] = []
    var trails: [NSLayoutConstraint] = []
    var numberOfMeasureLine = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScroller()
        setMainTitleLabel()
        addGesture()
        setCentreLine()
        setMeasureLine()
    }
    func test() {
        
    }

    private func setScroller() {
        self.view.addSubview(scroller)
        scroller.frame = CGRect(x: self.view.center.x - 20, y: self.view.center.y, width: 100, height: 100)
        scroller.layer.cornerRadius = 50
        scroller.backgroundColor = .systemBlue
        
        scrollerBackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollerBackView)
        scrollerBackView.backgroundColor = .white
        scrollerBackView.widthAnchor.constraint(equalTo: scroller.widthAnchor, constant: 40).isActive = true
        scrollerBackView.heightAnchor.constraint(equalTo: scroller.heightAnchor, constant: 40).isActive = true
        scrollerBackView.centerXAnchor.constraint(equalTo: scroller.centerXAnchor).isActive = true
        scrollerBackView.centerYAnchor.constraint(equalTo: scroller.centerYAnchor).isActive = true
        scrollerBackView.layer.cornerRadius = 70
        scrollerBackView.layer.borderWidth = 3
        scrollerBackView.layer.borderColor = UIColor.white.cgColor
        self.view.bringSubviewToFront(scroller)
        getOutherGrayCircle()
    }
    
    func getOutherGrayCircle() {
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: CGPoint(x: 70, y: 70),
                      radius: 70,
                          startAngle: (CGFloat.pi * 3 / 2) - 0.42,
                          endAngle: (CGFloat.pi / 2) + 0.42,
                      clockwise: false)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath

        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 5.0

        scrollerBackView.layer.addSublayer(shapeLayer)
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
        mainTitleLabel.text = String(Int((scroller.center.y + translation.y) / 10))
        
        let y: Int = Int(scrollerBackView.frame.origin.y / 53)
        for i in 0..<3 {
            UIView.animate(withDuration: 0.5) { [self] in
                trails[y + i].isActive = false
                if i != 1 {
                    trails[y + i] = lines[y + i].trailingAnchor.constraint(equalTo: scrollerBackView.leadingAnchor, constant: -5)
                } else {
                    trails[y + i] = lines[y + i].trailingAnchor.constraint(equalTo: scrollerBackView.leadingAnchor, constant: -20)
                }
                trails[y + i].isActive = true
                
                if i == 0 && y > 0 {
                    trails[y - 1].isActive = false
                    trails[y - 1] = lines[y - 1].trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10)
                    trails[y - 1].isActive = true
                }
                
                if i == 2 && y < numberOfMeasureLine - 3 {
                    trails[y + 3].isActive = false
                    trails[y + 3] = lines[y + 3].trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10)
                    trails[y + 3].isActive = true
                }
            }
        }
    }
    
    private func setCentreLine() {
        self.view.layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3.0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let verticalLine = UIBezierPath()
        verticalLine.move(to: CGPoint(x: self.view.bounds.midX, y: 0))
        verticalLine.addLine(to: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY))
        shapeLayer.path = verticalLine.cgPath
    }
    
    private func setMeasureLine() {
        let height = self.view.frame.height
        numberOfMeasureLine = Int(height / 50)

        for i in 0..<numberOfMeasureLine {
            let line = UIView()
            line.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(line)
            line.backgroundColor = .black
            line.widthAnchor.constraint(equalToConstant: 20).isActive = true
            line.heightAnchor.constraint(equalToConstant: 3).isActive = true
            if i == 0 {
                line.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            } else {
                line.topAnchor.constraint(equalTo: lines[i-1].bottomAnchor, constant: 53).isActive = true
            }

            let trail: NSLayoutConstraint = line.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10)
            trail.isActive = true
            
            let number = UILabel()
            number.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(number)
            number.text = "100"
            number.heightAnchor.constraint(equalToConstant: 30).isActive = true
            number.widthAnchor.constraint(equalToConstant: 40).isActive = true
            number.centerYAnchor.constraint(equalTo: line.centerYAnchor).isActive = true
            number.trailingAnchor.constraint(equalTo: line.leadingAnchor, constant: -10).isActive = true
            
            lines.append(line)
            trails.append(trail)
            numbers.append(number)
        }
    }
}

