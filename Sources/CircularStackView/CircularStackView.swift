import SwiftUI

struct CircularStackView<Content: View>: View {
    
    var startAngle: CGFloat
    var endAngle: CGFloat
    var radius: CGFloat
    var keepChildrenUpright: Bool
    var uprightChildZRotation: Double
    let childOffsets: [(offset: CGSize, zRotation: Angle)]
    
    let content: (Int) -> Content
    
    var body: some View {
        ZStack {
            ForEach(0..<childOffsets.count) { index in
                content(index)
                    .rotationEffect(childOffsets[index].zRotation)
                    .offset(childOffsets[index].offset)
            }
        }
        .frame(width: radius*2, height: radius*2)
    }
    
    init(childCount: Int, startAngle: CGFloat = -.pi*1.5, endAngle: CGFloat = .pi/2, radius: CGFloat, keepChildrenUpright: Bool, uprightChildZRotation: Double = 0.0, @ViewBuilder content: @escaping (Int) -> Content) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.radius = radius
        self.keepChildrenUpright = keepChildrenUpright
        self.uprightChildZRotation = uprightChildZRotation
        
        var denominator = CGFloat(childCount)
        let diffFrom2PI = abs(abs(endAngle - startAngle) - .pi*2)
        if 0.01 < diffFrom2PI {
            denominator -= 1.0
        }
        let angleStep = (1.0 / denominator) * (endAngle - startAngle)
        var offsets = [(CGSize, Angle)]()
        for index in 0..<childCount {
            let offsetAngle = startAngle + angleStep * CGFloat(index)
            let offset = CGSize(width: radius * cos(offsetAngle), height: radius * sin(offsetAngle))
            var childZRotation = uprightChildZRotation
            if !keepChildrenUpright {
                childZRotation += Double(offsetAngle) + .pi/2
            }
            offsets.append((offset, Angle(radians: childZRotation)))
        }
        
        self.childOffsets = offsets
        self.content = content
    }
}

struct CircularStackView_Previews: PreviewProvider {
    static var previews: some View {
        CircularStackView(childCount: 5, radius: 100.0, keepChildrenUpright: true) { index in
            switch index {
            case 0:
                Text("0")
            case 1:
                Text("1")
            case 2:
                Text("2")
            case 3:
                Text("3")
            default:
                Text("...")
            }
        }
    }
}
