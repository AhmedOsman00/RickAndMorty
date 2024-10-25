import SwiftUI
import SDWebImageSwiftUI
import SDWebImage
import UIExtensions

struct FilterCell: View {
    let model: FilterUiModel
    
    var body: some View {
        Text(model.status.rawValue)
            .font(.subheadline)
            .foregroundStyle(.primary)
            .padding(10)
            .inRect(fillColor: model.isSelected ? model.status.backgroundColor : .clear)
    }
}

#Preview {
    FilterCell(model: .init(status: .dead, isSelected: true))
}
