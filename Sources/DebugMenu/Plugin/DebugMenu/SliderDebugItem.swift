import Foundation

public struct SliderDebugItem: DebugItem {
    public init(
        title: String,
        current: @escaping () -> Double,
        valueLabelText: @escaping (Double) -> String = { String(format: "%.2f", $0) },
        range: ClosedRange<Double> = 0.0...1.0,
        onChange: @escaping (Double) -> Void
    ) {
        self.title = title
        self.action = .slider(
            current: current,
            valueLabelText: valueLabelText,
            range: range,
            operation: { (value) in
                onChange(value)
                return .success()
            }
        )
    }

    let title: String
    public var debugItemTitle: String { title }
    public let action: DebugItemAction
}
