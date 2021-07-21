//
//  FloatingItemGestureRecognizer.swift
//  UI
//
//  Created by Tomoya Hirano on 2020/11/30.
//

import UIKit

public class FloatingItemGestureRecognizer: UIPanGestureRecognizer {
    private weak var groundView: UIView?
    private var gestureGap: CGPoint?
    private let margin: CGFloat = 16
    public enum Edge {
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
    }

    public init(groundView: UIView) {
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(pan(_:)))
        self.groundView = groundView

    }

    deinit {
        self.removeTarget(self, action: #selector(pan(_:)))
    }

    public func moveInitialPosition(_ edge: Edge = .bottomTrailing) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.center = self?.cornerPositions()[edge] ?? .zero
            UIView.animate(
                withDuration: 0.2,
                animations: { [weak self] in
                    self?.view?.alpha = 1.0
                }
            )
        }
    }

    @objc private func pan(_ gesture: UIPanGestureRecognizer) {
        guard let targetView = self.view else { return }
        guard let groundView = groundView else { return }
        switch gesture.state {
        case .began:
            // ジェスチャ座標とオブジェクトの中心座標までの“ギャップ”を計算

            let location = gesture.location(in: groundView)
            let gap = CGPoint(
                x: targetView.center.x - location.x,
                y: targetView.center.y - location.y
            )
            self.gestureGap = gap

        case .ended:
            let lastObjectLocation = targetView.center
            let velocity = gesture.velocity(in: groundView)  // points per second

            // 仮想の移動先を計算
            let projectedPosition = CGPoint(
                x: lastObjectLocation.x
                    + project(initialVelocity: velocity.x, decelerationRate: .fast),
                y: lastObjectLocation.y
                    + project(initialVelocity: velocity.y, decelerationRate: .fast)
            )
            // 最適な移動先を計算
            let destination = nearestCornerPosition(projectedPosition)

            let initialVelocity = initialAnimationVelocity(
                for: velocity,
                from: self.view!.center,
                to: destination
            )

            // iOSの一般的な動きに近い動きを再現
            let parameters = UISpringTimingParameters(
                dampingRatio: 0.5,
                initialVelocity: initialVelocity
            )
            let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: parameters)

            animator.addAnimations {
                self.view!.center = destination
            }
            animator.startAnimation()

            self.gestureGap = nil

        default:
            // ジェスチャに合わせてオブジェクトをドラッグ

            let gestureGap = self.gestureGap ?? CGPoint.zero
            let location = gesture.location(in: groundView)
            let destination = CGPoint(x: location.x + gestureGap.x, y: location.y + gestureGap.y)
            self.view!.center = destination

        }
    }

    // アニメーション開始時の変化率を計算
    private func initialAnimationVelocity(
        for gestureVelocity: CGPoint,
        from currentPosition: CGPoint,
        to finalPosition: CGPoint
    ) -> CGVector {
        // https://developer.apple.com/documentation/uikit/uispringtimingparameters/1649909-initialvelocity

        var animationVelocity = CGVector.zero
        let xDistance = finalPosition.x - currentPosition.x
        let yDistance = finalPosition.y - currentPosition.y

        if xDistance != 0 {
            animationVelocity.dx = gestureVelocity.x / xDistance
        }
        if yDistance != 0 {
            animationVelocity.dy = gestureVelocity.y / yDistance
        }

        return animationVelocity
    }

    // 仮想の移動先を計算
    private func project(initialVelocity: CGFloat, decelerationRate: UIScrollView.DecelerationRate)
        -> CGFloat
    {
        // https://developer.apple.com/videos/play/wwdc2018/803/

        return (initialVelocity / 1000.0) * decelerationRate.rawValue
            / (1.0 - decelerationRate.rawValue)
    }

    // 引数にもっとも近い位置を返す
    private func nearestCornerPosition(_ projectedPosition: CGPoint) -> CGPoint {
        let destinations = cornerPositions()
        let nearestPosition =
            destinations.sorted(by: {
                return distance(from: $0.value, to: projectedPosition)
                    < distance(from: $1.value, to: projectedPosition)
            })
            .first!

        return nearestPosition.value
    }

    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }

    private func cornerPositions() -> [Edge: CGPoint] {
        guard let targetView = self.view else { return [:] }
        guard let groundView = groundView else { return [:] }
        let viewSize = groundView.bounds.size
        let objectSize = targetView.bounds.size
        let xCenter = targetView.bounds.width / 2
        let yCenter = targetView.bounds.height / 2
        let safeAreaInsets = groundView.safeAreaInsets

        let topLeading = CGPoint(
            x: self.margin + xCenter + safeAreaInsets.left,
            y: self.margin + yCenter + safeAreaInsets.top
        )

        let topTrailing = CGPoint(
            x: viewSize.width - objectSize.width - self.margin + xCenter - safeAreaInsets.right,
            y: self.margin + yCenter + safeAreaInsets.top
        )
        let bottomLeading = CGPoint(
            x: self.margin + xCenter + safeAreaInsets.left,
            y: viewSize.height - objectSize.height - self.margin + yCenter - safeAreaInsets.bottom
        )

        let bottomTrailing = CGPoint(
            x: viewSize.width - objectSize.width - self.margin + xCenter - safeAreaInsets.right,
            y: viewSize.height - objectSize.height - self.margin + yCenter - safeAreaInsets.bottom
        )
        return [
            .topLeading: topLeading,
            .topTrailing: topTrailing,
            .bottomLeading: bottomLeading,
            .bottomTrailing: bottomTrailing,
        ]
    }
}
