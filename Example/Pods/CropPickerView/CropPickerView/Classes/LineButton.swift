//Copyright (c) 2018 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

// Called when the button's highlighted is false.
protocol LineButtonDelegate: class {
    func lineButtonUnHighlighted()
}

// Side, Edge LineButton
class LineButton: UIButton {
    weak var delegate: LineButtonDelegate?
    
    private var type: ButtonLineType
    
    override var isHighlighted: Bool {
        didSet {
            if !self.isHighlighted {
                self.delegate?.lineButtonUnHighlighted()
            }
        }
    }
    
    // MARK: Init
    func addEdgeButtonsCostraints(view: UIView) {
        if type != .center {
            if #available(iOS 9.0, *) {
                NSLayoutConstraint.activate([
                    self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33),
                    self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33)
                ])
            }
            self.alpha = 0
        }
    }
    
    init(_ type: ButtonLineType) {
        self.type = type
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.setTitle(nil, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func edgeLine(_ color: UIColor?) {
        self.setImage(self.type.view(color)?.imageWithView?.withRenderingMode(.alwaysOriginal), for: .normal)
        if #available(iOS 9.0, *) {
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            switch type {
            case .leftBottom:
                imageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
                imageView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            case .leftTop:
                imageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
                imageView?.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            case.rightTop:
                imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
                imageView?.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            case .rightBottom:
                imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
                imageView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            default:
                break
            }
        }
    }
}

enum ButtonLineType {
    case center
    case leftTop, rightTop, leftBottom, rightBottom, top, left, right, bottom
    
    var rotate: CGFloat {
        switch self {
        case .leftTop:
            return 0
        case .rightTop:
            return CGFloat.pi/2
        case .rightBottom:
            return CGFloat.pi
        case .leftBottom:
            return CGFloat.pi/2*3
        case .top:
            return 0
        case .left:
            return CGFloat.pi/2*3
        case .right:
            return CGFloat.pi/2
        case .bottom:
            return CGFloat.pi
        case .center:
            return 0
        }
    }
    
    var yMargin: CGFloat {
        switch self {
        case .rightBottom, .bottom:
            return 1
        default:
            return 0
        }
    }
    
    var xMargin: CGFloat {
        switch self {
        case .leftBottom:
            return 1
        default:
            return 0
        }
    }
    
    func view(_ color: UIColor?) -> UIView? {
        var view: UIView?
        if self == .leftTop || self == .rightTop || self == .leftBottom || self == .rightBottom {
            view = ButtonLineType.EdgeView(self, color: color)
        } else {
            view = ButtonLineType.SideView(self, color: color)
        }
        view?.isOpaque = false
        view?.tintColor = color
        return view
    }
    
    class LineView: UIView {
        var type: ButtonLineType
        var color: UIColor?
        init(_ type: ButtonLineType, color: UIColor?) {
            self.type = type
            self.color = color
            super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func apply(_ path: UIBezierPath) {
            var pathTransform  = CGAffineTransform.identity
            pathTransform = pathTransform.translatedBy(x: 25, y: 25)
            pathTransform = pathTransform.rotated(by: self.type.rotate)
            pathTransform = pathTransform.translatedBy(x: -25 - self.type.xMargin, y: -25 - self.type.yMargin)
            path.apply(pathTransform)
            path.closed()
                .strokeFill(self.color ?? .white)
        }
    }
    
    class EdgeView: LineView {
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
                .move(0, 0)
                .line(0, 20)
                .line(2, 20)
                .line(2, 2)
                .line(20, 2)
                .line(20, 0)
                .line(0, 0)
            self.apply(path)
        }
    }
    class SideView: LineView {
        override func draw(_ rect: CGRect) {
//            let path = UIBezierPath()
//                .move(15, 6)
//                .line(35, 6)
//                .line(35, 8)
//                .line(15, 8)
//                .line(15, 6)
//            self.apply(path)
        }
    }
}
