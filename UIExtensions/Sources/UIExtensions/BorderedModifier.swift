import SwiftUI

public struct BorderedModifier: ViewModifier {
    let cornerRadius: CGFloat
    let fillColor: Color
    let isBordered: Bool
    
    public func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
                if isBordered {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.secondary.opacity(0.5), lineWidth: 1)
                }
            }
    }
}

extension View {
    public func inRect(cornerRadius: CGFloat = 20,
                       isBordered: Bool = true,
                       fillColor: Color) -> some View {
        self.modifier(BorderedModifier(cornerRadius: cornerRadius,
                                       fillColor: fillColor,
                                       isBordered: isBordered))
    }
}
