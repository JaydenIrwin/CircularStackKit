# CircularStackKit

A SwiftUI view that organizes it's children on a circular path. 

## Flexible Options:
- Set start and end angles of the path to layout children on only the top half of a circle for example.
- Use the angle given in the closure to rotate children along with the circular path, if you wish.

## Usage
The content closure provides you (index: Int, rotationAngle: Angle) for each child view you should return. Use a switch statement in here to provide different views for each index. Optionally use the angle to rotate elements of your child views.
