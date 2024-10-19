//
//  TagView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import SwiftUI

struct TagView: View {
    var title: String
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100).fill(Color.white)
            HStack(spacing: 4) { // Add spacing here if you want a specific gap between icon and text
                Image("personal_development")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.yaleBlue)
                
                Text(title)
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .headline))
                    .fontWeight(.regular)
                    .foregroundColor(.yaleBlue)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .fixedSize()
    }
}

struct CategoryTagView: View {
    @State var isSelected: Bool = false
    var categoryName: String
    var categoryId: String
    var icon: String
    var onTap: (String) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(isSelected ? Color.yaleBlue : Color.white).stroke(Color.yaleBlue, lineWidth: 1)
            HStack(spacing: 10) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(isSelected ? .white : .yaleBlue)
                
                Text(categoryName)
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .headline))
                    .fontWeight(.regular)
                    .foregroundColor(isSelected ? .white : .yaleBlue)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .fixedSize()
        .onTapGesture {
            isSelected = !isSelected
            onTap(categoryId)
        }
    }
}

/*
 * Source: https://blog.logrocket.com/implementing-tags-swiftui/
 */
struct FlowLayout<Data, RowContent>: View where Data: RandomAccessCollection, RowContent: View, Data.Element: Identifiable, Data.Element: Hashable {
  @State private var height: CGFloat = .zero

  private var data: Data
  private var spacing: CGFloat
  private var rowContent: (Data.Element) -> RowContent

  public init(_ data: Data, spacing: CGFloat = 4, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) {
    self.data = data
    self.spacing = spacing
    self.rowContent = rowContent
  }

  var body: some View {
    GeometryReader { geometry in
      content(in: geometry)
        .background(viewHeight(for: $height))
    }
    .frame(height: height)
  }

  private func content(in geometry: GeometryProxy) -> some View {
    var bounds = CGSize.zero

    return ZStack {
      ForEach(data) { item in
        rowContent(item)
          .padding(.all, spacing)
          .alignmentGuide(VerticalAlignment.center) { dimension in
            let result = bounds.height

            if let firstItem = data.first, item == firstItem {
              bounds.height = 0
            }
            return result
          }
          .alignmentGuide(HorizontalAlignment.center) { dimension in
            if abs(bounds.width - dimension.width) > geometry.size.width {
              bounds.width = 0
              bounds.height -= dimension.height
            }

            let result = bounds.width

            if let firstItem = data.first, item == firstItem {
              bounds.width = 0
            } else {
              bounds.width -= dimension.width
            }
            return result
          }
      }
    }
  }

  private func viewHeight(for binding: Binding<CGFloat>) -> some View {
    GeometryReader { geometry -> Color in
      let rect = geometry.frame(in: .local)

      DispatchQueue.main.async {
        binding.wrappedValue = rect.size.height
      }
      return .clear
    }
  }
}


#Preview {
    TagView(title: "Productivity")
}

#Preview {
    CategoryTagView(categoryName: "Business & Career", categoryId: "business-career", icon: "productivity", onTap: { categoryId in })
}
