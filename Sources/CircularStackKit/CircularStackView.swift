import SwiftUI
import ViewExtractor

public struct CircularStackView: View {
    
    struct ChildPosition {
        let offset: CGSize
        let upIsOutwardAngle: Angle
    }
    public enum ChildRotationMode {
        case none, upIsOutward, upIsInward
    }
    
    private var views: [AnyView]
    var startAngle: CGFloat
    var endAngle: CGFloat
    var radius: CGFloat
    var childRotationMode: ChildRotationMode
    let childPositions: [ChildPosition]
    
    public var body: some View {
        ZStack {
            ForEach(views.indices) { index in
                views[index]
                    .rotationEffect({
                        switch childRotationMode {
                        case .none:
                            return .zero
                        case .upIsOutward:
                            return childPositions[index].upIsOutwardAngle
                        case .upIsInward:
                            return childPositions[index].upIsOutwardAngle - Angle(radians: .pi)
                        }
                    }())
                    .offset(childPositions[index].offset)
            }
        }
        .frame(width: radius*2, height: radius*2)
    }
    
    public init<Content: View>(startAngle: CGFloat = -.pi*1.5, endAngle: CGFloat = .pi/2, radius: CGFloat, childRotation: ChildRotationMode = .none, @ViewBuilder content: NormalContent<Content>) {
        self.views = ViewExtractor.getViews(from: content)
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.radius = radius
        self.childRotationMode = childRotation
        
        let offsetAngle = (startAngle + endAngle) / 2
        let offset = CGSize(width: radius * cos(offsetAngle), height: radius * sin(offsetAngle))
        let rotationAngle = Double(offsetAngle) + .pi/2
        self.childPositions = [ChildPosition(offset: offset, upIsOutwardAngle: Angle(radians: rotationAngle))]
    }
    
    public init<Views>(startAngle: CGFloat = -.pi*1.5, endAngle: CGFloat = .pi/2, radius: CGFloat, childRotation: ChildRotationMode = .none, @ViewBuilder content: TupleContent<Views>) {
        self.views = ViewExtractor.getViews(from: content)
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.radius = radius
        self.childRotationMode = childRotation
        
        var denominator = CGFloat(views.count)
        let diffFrom2PI = abs(abs(endAngle - startAngle) - .pi*2)
        if 0.01 < diffFrom2PI {
            denominator -= 1.0
        }
        let angleStep = (1.0 / denominator) * (endAngle - startAngle)
        var positions = [ChildPosition]()
        for index in 0..<views.count {
            let offsetAngle = startAngle + angleStep * CGFloat(index)
            let offset = CGSize(width: radius * cos(offsetAngle), height: radius * sin(offsetAngle))
            let rotationAngle = Double(offsetAngle) + .pi/2
            positions.append(ChildPosition(offset: offset, upIsOutwardAngle: Angle(radians: rotationAngle)))
        }
        
        self.childPositions = positions
    }
    
}

struct CircularStackView_Previews: PreviewProvider {
    static var previews: some View {
        CircularStackView(radius: 100.0) {
            Text("0")
            Text("1")
            Text("2")
            Text("3")
            Text("...")
        }
    }
}
