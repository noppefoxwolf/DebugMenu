import Foundation
import Metal

final class GPU {
    static var current: GPU { GPU() }
    let device: MTLDevice

    init() {
        device = MTLCreateSystemDefaultDevice()!
    }

    var currentAllocatedSize: Int {
        device.currentAllocatedSize
    }
}
