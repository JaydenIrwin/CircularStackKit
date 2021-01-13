import SwiftUI

public struct CircularStackView<Content: View>: View {
    
    struct ChildPosition: Identifiable {
        let index: Int
        var id: Int {
            index
        }
        let offset: CGSize
        let rotationAngle: Angle
    }
    
    var startAngle: CGFloat
    var endAngle: CGFloat
    var radius: CGFloat
    let childPositions: [ChildPosition]
    
    let content: (Int, Angle) -> Content
    
    public var body: some View {
        ZStack {
            ForEach(childPositions) { pos in
                content(pos.index, pos.rotationAngle)
                    .offset(pos.offset)
            }
        }
        .frame(width: radius*2, height: radius*2)
    }
    
    public init(childCount: Int, startAngle: CGFloat = -.pi*1.5, endAngle: CGFloat = .pi/2, radius: CGFloat, @ViewBuilder content: @escaping (Int, Angle) -> Content) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.radius = radius
        
        var denominator = CGFloat(childCount)
        let diffFrom2PI = abs(abs(endAngle - startAngle) - .pi*2)
        if 0.01 < diffFrom2PI {
            denominator -= 1.0
        }
        let angleStep = (1.0 / denominator) * (endAngle - startAngle)
        var positions = [ChildPosition]()
        for index in 0..<childCount {
            let offsetAngle = startAngle + angleStep * CGFloat(index)
            let offset = CGSize(width: radius * cos(offsetAngle), height: radius * sin(offsetAngle))
            let rotationAngle = Double(offsetAngle) + .pi/2
            positions.append(ChildPosition(index: index, offset: offset, rotationAngle: Angle(radians: rotationAngle)))
        }
        
        self.childPositions = positions
        self.content = content
    }
}

struct CircularStackView_Previews: PreviewProvider {
    static var previews: some View {
        CircularStackView(childCount: 5, radius: 100.0) { index, angle in
            switch index {
            case 0:
                Text("0")
                    .rotationEffect(angle) // If you want this to follow the angle of the circle
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
