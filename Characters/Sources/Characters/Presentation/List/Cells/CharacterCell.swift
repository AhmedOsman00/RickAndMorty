import SwiftUI
import SDWebImageSwiftUI
import Resources
import UIExtensions

struct CharacterCell: View {
    let name: String
    let specie: String
    let imageUrl: URL
    let backgroundColor: Color
    let isBordered: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            WebImage(url: imageUrl)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 20))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .bold()
                    .font(.title2)
                    .foregroundStyle(.primary)
                Text(specie)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .inRect(isBordered: isBordered, fillColor: backgroundColor)
    }
}

#Preview {
    CharacterCell(name: "Rick Sanche",
                  specie: "Human",
                  imageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
                  backgroundColor: .frostedSky,
                  isBordered: false)
}
