import SwiftUI

/// Scrollable list of shops with navigation into the detail screen.
///
/// Shared by the Popular and Favourite tabs so list styling and navigation
/// behaviour are defined once.
struct ShopListView: View {
    let shops: [SakeShop]

    private var rowInsets: EdgeInsets {
        EdgeInsets(
            top: AppTheme.Layout.listRowVerticalInset,
            leading: AppTheme.Layout.listRowHorizontalInset,
            bottom: AppTheme.Layout.listRowVerticalInset,
            trailing: AppTheme.Layout.listRowHorizontalInset
        )
    }

    var body: some View {
        List(shops) { shop in
            NavigationLink(value: shop) {
                SakeShopRow(shop: shop)
            }
            .buttonStyle(CardButtonStyle())
            .listRowSeparator(.hidden)
            .listRowInsets(rowInsets)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationDestination(for: SakeShop.self) { shop in
            SakeDetailView(shop: shop)
        }
    }
}
