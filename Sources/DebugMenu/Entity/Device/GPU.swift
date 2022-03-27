import Foundation
import Metal

class GPU {
    static var current: GPU = .init()
    let device: MTLDevice

    init() {
        device = MTLCreateSystemDefaultDevice()!
    }

    var currentAllocatedSize: Int {
        device.currentAllocatedSize
    }
}
