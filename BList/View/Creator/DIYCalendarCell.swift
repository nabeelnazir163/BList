//
//  DIYCalendarCell.swift
//  CalendarDemo
//
//  Created by iOS TL on 26/05/22.
//

import Foundation
import FSCalendar
//rgba(249, 106, 39, 1)
public var selectedColor = UIColor.init(red: 249/255, green: 106/255, blue: 39/255, alpha: 1)

enum SelectionType : Int {
    case none
    case single
    case singleLeft
    case singleRight
    case leftBorder
    case middle
    case rightBorder
    case noBackground
}
class DIYCalendarCell: FSCalendarCell {
    let gradientLayer = CAGradientLayer()
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.removeFromSuperlayer()
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = selectedColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer

        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view;

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        gradientLayer.removeFromSuperlayer()
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {

            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single{
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath

        }
        else if selectionType == .singleLeft {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath

            gradientLayer.frame = self.contentView.frame
            gradientLayer.colors = [UIColor.white.cgColor, UIColor(red:249/255, green: 106/255, blue: 39/238, alpha: 0.1).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.locations = [0.5,1]
            gradientLayer.endPoint = CGPoint(x:1, y: 0.5)//Add different color here
            self.contentView.layer.addSublayer(gradientLayer)
            self.contentView.layer.insertSublayer(gradientLayer, below: selectionLayer)
        }
        else if selectionType == .singleRight {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            gradientLayer.frame = self.contentView.frame
            gradientLayer.locations = [0,0.5]
            gradientLayer.colors = [UIColor(red:249/255, green: 106/255, blue: 39/238, alpha: 0.1).cgColor, UIColor.white.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x:1, y: 0.5)//Add different color here
            self.contentView.layer.addSublayer(gradientLayer)
            self.contentView.layer.insertSublayer(gradientLayer, below: selectionLayer)
        }
        else{
            
        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
    
        }
    }

}

