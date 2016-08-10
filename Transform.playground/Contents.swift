//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground

let π = CGFloat(M_PI)

public extension CGFloat {
    public func degreesToRadians() -> CGFloat {
        return π * self / 180.0
    }
}

class CustomView: NSView {
    
    override init(frame: NSRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        color.setFill()
        NSRectFill(self.bounds)
        NSColor.yellowColor().setFill()
        let r = NSMakeRect(0, y, self.bounds.width, 5)
        NSRectFill(r)
    }
    
    var color = NSColor.greenColor()
    var y: CGFloat = 0
    
    // Add other UI components to test they are rotating together
    func addUI() {
        let subview = NSView(frame: NSRect(x: 50, y: 50, width: 200, height: 200))
        //subview.wantsLayer = true
        subview.layer?.backgroundColor = NSColor.blueColor().CGColor
        self.addSubview(subview)
        
        let textField = NSTextField(frame: NSRect(x: 80, y: 80, width: 120, height: 30))
        textField.stringValue = "Testing Something"
        textField.editable = true
        self.addSubview(textField)
    }
    
    // Change anchorPoint for rotation
    func move(anchorPoint anchorPoint: CGPoint) {
        wantsLayer = true
        
        var newPoint = CGPointMake(bounds.size.width * anchorPoint.x, bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(bounds.size.width * layer!.anchorPoint.x, bounds.size.height * layer!.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, layer!.affineTransform())
        oldPoint = CGPointApplyAffineTransform(oldPoint, layer!.affineTransform())
        
        var position = layer!.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer!.position = position
        layer!.anchorPoint = anchorPoint
    }
    
    // Set transform at certain angle
    func setAngle(degress: Int) {
        let radians = CGFloat(degress).degreesToRadians()
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        transform = CATransform3DRotate(transform, radians, 1, 0, 0)
        layer?.transform = transform
    }
    
    // Set initial state
    func prep() {
        layer?.transform = CATransform3DIdentity
        
        setAngle(-45)
    }
    
    // Animate to plane view
    func animateToAngle() {
        CATransaction.begin()
        
        // Completion Block should be set before the animation is added to the layer
        CATransaction.setCompletionBlock { [unowned self] in
            self.removeFromSuperview()
        }
        
        let rotationAtStart = layer?.valueForKeyPath("transform.rotation.x") as? NSNumber
        let rotate = CABasicAnimation(keyPath: "transform.rotation.x")
        rotate.duration = 1
        rotate.fromValue = rotationAtStart
        rotate.toValue = NSNumber(float: 0)
        layer?.addAnimation(rotate, forKey: "transform.rotation.x")
        
        CATransaction.commit()
    }
    
    // Animate to fade out
    func fadeOut() {
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = NSNumber(float: 1)
        fadeAnim.toValue = NSNumber(float: 0)
        fadeAnim.duration = 1
        layer?.addAnimation(fadeAnim, forKey: "opacity")
    }
}

var view = CustomView(frame:
    NSRect(x: 0, y: 0, width: 300, height: 300))

view.color = NSColor.greenColor()

// Add view to view hierarchy before setting transform
XCPlaygroundPage.currentPage.liveView = view

view.addUI()
view.move(anchorPoint: CGPoint(x: 0.5, y: 0))
view.prep()

view.animateToAngle()
view.fadeOut()

//XCPlaygroundPage.currentPage.liveView = view










