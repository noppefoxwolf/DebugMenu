//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/30.
//

import UIKit

class GraphView: UIView {
    private var maxValue: Double = 0
    private var capacity: Int = 60
    private var data: [Double] = []

    func setCapacity(_ capacity: Int) {
        self.capacity = capacity
        setNeedsDisplay()
    }

    func append(data: Double) {
        self.data.append(data)
        if self.data.count >= 10 {
            self.data.removeFirst()
        }
        self.maxValue = max(self.maxValue, data)
        setNeedsDisplay()
    }

    func reload(data: [Double], capacity: Int, maxValue: Double? = nil) {
        self.data = data.suffix(capacity).map({ $0 })
        self.capacity = capacity
        self.maxValue = maxValue ?? data.max() ?? 0
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard data.count >= 1, data.count <= capacity else { return }
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)

        let graph = UIBezierPath()

        graph.move(to: .init(x: 0, y: rect.height))

        for (index, data) in data.enumerated() {
            let x = rect.width * CGFloat(index) / CGFloat(capacity)
            let y = rect.height - CGFloat(data / maxValue) * rect.height
            graph.addLine(to: .init(x: x, y: y))
        }
        last: do {
            let x = rect.width * CGFloat(data.count - 1) / CGFloat(capacity)
            graph.addLine(to: .init(x: x, y: rect.size.height))
        }
        graph.addLine(to: .init(x: rect.size.width, y: rect.size.height))
        graph.addLine(to: .init(x: 0, y: rect.height))
        graph.close()
        UIColor.lightGray.setFill()
        graph.fill()

        let string = String(format: "%.2f", maxValue)
        let text = NSAttributedString(
            string: string,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.preferredFont(forTextStyle: .caption1),
            ]
        )
        text.draw(at: .zero)
    }
}
