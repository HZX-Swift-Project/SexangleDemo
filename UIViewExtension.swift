//
//  UIViewExtension.swift
//  SexangleDemo
//
//  Created by Meet on 2021/3/9.
//

import UIKit
// MARK: ---------------------------------- 绘制六边形
extension UIView {
    /// 三角方向
    enum TriangleDerection {
        case left
        case right
        case both
        case none
    }
    /// 给视图绘制六边形
    /// - Parameters:
    ///   - type: 六边形
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    ///   - radius: 弧度的半径
    func setSixBorder(_ type: TriangleDerection = .both, borderColor: UIColor = .clear, borderWidth: CGFloat = 2.0, radius: CGFloat = 6) {
        self.layoutIfNeeded()
        /// 移除已经存在的layer，加这一步的目的是多次操作后会在当前layer上就会有多个子layer 特别是在tableViewCell中可能出现问题
        self.layer.sublayers?.forEach({ (sulayer) in
            if sulayer.isKind(of: CAShapeLayer.self) {
                sulayer.removeFromSuperlayer()
            }
        })
    
        if type == .none {
            /// 如果没有剪切 那么移除所有直接返回 这个情况基本上不会出现 但是写上也不会多余
            return
        }
        
        /// 获取切割路径
        let maskPath = getSexanglePath(type, radius: radius)
        
        /// 创建切割路径Layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        /// 创建路径边框
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = borderWidth
        self.layer.addSublayer(shapeLayer)
    }
    
    private func getSexanglePath(_ type: TriangleDerection = .both, radius: CGFloat) -> UIBezierPath {
        /// 定义PI值
        let PI = CGFloat(Double.pi)
        /// 弧度半径
        let radius: CGFloat = radius
        /// 视图的宽
        let allWidth = self.bounds.size.width
        /// 视图的高
        let allHeight = self.bounds.size.height
        /// 视图高度的一半
        let LayerHeigh = self.bounds.size.height/2
        /// 六边形的一个内角度数（这里默认是正六边形 所以一个角是120度）
        let sixDegree: CGFloat = PI*2/3
        let operateDegree:CGFloat = PI - sixDegree
        /// 圆弧与上边线的切点 到左上角的距离
        let distance = radius / tan(operateDegree)
        /// 左边定点到左上角之间的X狙击
        let maxDistance = LayerHeigh / tan(operateDegree)
        
        
        /// 计算第一个点
        let firstPointX = allWidth - (maxDistance + distance)
        let firstPoint = CGPoint(x: firstPointX, y: 0)
        
        /// 计算第二个点
        let secondPointX = firstPointX + distance + distance*cos(operateDegree)
        let secondPointY = distance*sin(operateDegree)
        let secondPoint = CGPoint(x: secondPointX, y: secondPointY)
        
        /// 计算第三个点
        let thirdPointX = allWidth - distance*cos(operateDegree)
        let thirdPointY = LayerHeigh - distance*sin(operateDegree)
        let thirdPoint = CGPoint(x: thirdPointX, y: thirdPointY)
        
        /// 计算第四个点
        let fourPointY = LayerHeigh + distance*sin(operateDegree)
        let fourPoint = CGPoint(x: thirdPointX, y: fourPointY)
        
        /// 计算第五个点
        let fivePointY = allHeight - secondPoint.y
        let fivePoint = CGPoint(x: secondPoint.x, y: fivePointY)
        
        /// 计算第六个点
        let sixPoint = CGPoint(x: firstPoint.x, y: allHeight)
        
        /// 第七个点
        let sevenPointX = maxDistance + distance
        let sevenPoint = CGPoint(x: sevenPointX, y: allHeight)
        
        /// 第八个点
        let eightPointX = maxDistance  - distance*cos(operateDegree)
        let eightPoint = CGPoint(x: eightPointX, y: fivePointY)
        
        /// 第九个点
        let ninePointX = distance*cos(operateDegree)
        let ninePoint = CGPoint(x: ninePointX, y: fourPointY)
        
        /// 第十个点
        let tenPoint = CGPoint(x: ninePointX, y: thirdPointY)
        
        /// 第十一个点
        let elevenPoint = CGPoint(x: eightPoint.x, y: secondPoint.y)
        
        /// 第十二个点
        let twelvePoint = CGPoint(x: sevenPoint.x, y: 0)
        
        /// 第一个圆弧圆心坐标
        let center1 = CGPoint(x: firstPoint.x, y: radius)
        /// 第二个圆弧圆心坐标
        let center2 = CGPoint(x: allWidth - distance/cos(operateDegree), y: LayerHeigh)
        /// 第三个圆弧圆心坐标
        let center3 = CGPoint(x: sixPoint.x, y: allHeight - radius)
        /// 第四个圆弧圆心坐标
        let center4 = CGPoint(x: sevenPoint.x, y: allHeight - radius)
        /// 第五个圆弧圆心坐标
        let center5 = CGPoint(x: distance/cos(operateDegree), y: LayerHeigh)
        /// 第六个圆弧圆心坐标
        let center6 = CGPoint(x: twelvePoint.x, y: radius)
        
        let path = UIBezierPath()
        switch type {
        case .left:
            /// 只有左边有三角
            path.move(to: CGPoint(x: allWidth, y: 0))
            path.addLine(to: CGPoint(x: allWidth, y: allHeight))
            path.addLine(to: sevenPoint)
            path.addArc(withCenter: center4, radius: radius, startAngle: PI/2, endAngle: PI/2 + operateDegree, clockwise: true)
            path.addLine(to: ninePoint)
            path.addArc(withCenter: center5, radius: radius, startAngle: PI - operateDegree/2, endAngle: PI + operateDegree/2, clockwise: true)
            path.addLine(to: elevenPoint)
            path.addArc(withCenter: center6, radius: radius, startAngle: PI + operateDegree/2, endAngle: PI*3/2, clockwise: true)
        case .right:
            path.move(to: firstPoint)
            path.addArc(withCenter: center1, radius: radius, startAngle: CGFloat(-PI/2), endAngle: operateDegree - PI/2, clockwise: true)
            path.addLine(to: thirdPoint)
            path.addArc(withCenter: center2, radius: radius, startAngle: CGFloat(-operateDegree/2), endAngle: operateDegree/2, clockwise: true)
            path.addLine(to: fivePoint)
            path.addArc(withCenter: center3, radius: radius, startAngle: operateDegree/2, endAngle: PI/2, clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: allHeight))
            path.addLine(to: CGPoint(x: 0, y: 0))
        default :
            path.move(to: firstPoint)
            path.addArc(withCenter: center1, radius: radius, startAngle: CGFloat(-PI/2), endAngle: operateDegree - PI/2, clockwise: true)
            path.addLine(to: thirdPoint)
            path.addArc(withCenter: center2, radius: radius, startAngle: CGFloat(-operateDegree/2), endAngle: operateDegree/2, clockwise: true)
            path.addLine(to: fivePoint)
            path.addArc(withCenter: center3, radius: radius, startAngle: operateDegree/2, endAngle: PI/2, clockwise: true)
            path.addLine(to: sevenPoint)
            path.addArc(withCenter: center4, radius: radius, startAngle: PI/2, endAngle: PI/2 + operateDegree, clockwise: true)
            path.addLine(to: ninePoint)
            path.addArc(withCenter: center5, radius: radius, startAngle: PI - operateDegree/2, endAngle: PI + operateDegree/2, clockwise: true)
            path.addLine(to: elevenPoint)
            path.addArc(withCenter: center6, radius: radius, startAngle: PI + operateDegree/2, endAngle: PI*3/2, clockwise: true)
        }
        path.close()
        return path
    }
}

