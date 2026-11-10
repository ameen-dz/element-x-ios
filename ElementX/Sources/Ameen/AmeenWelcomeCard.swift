//
// Copyright 2026 Ameen.
//
// SPDX-License-Identifier: AGPL-3.0-only.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

/// The welcome card of the start screen, same design as the web app's sign-in page:
/// the full Ameen logo (v2) and the tagline on a white card (dark ink in dark mode).
struct AmeenWelcomeCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Image(asset: Asset.Images.ameenWelcomeLogo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 220)
                .accessibilityLabel(InfoPlistReader.main.bundleDisplayName)
                .accessibilityAddTraits(.isHeader)
            
            Text(L10n.tr("Ameen", "ameen_welcome_tagline"))
                .font(.compound.bodyLG)
                .foregroundColor(.compound.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .frame(maxWidth: 448)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(red: 16 / 255, green: 35 / 255, blue: 30 / 255) : .white)
                .shadow(color: shadowColor, radius: 32, y: 12)
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.6) : Color(red: 12 / 255, green: 31 / 255, blue: 26 / 255).opacity(0.18)
    }
}

struct AmeenWelcomeCard_Previews: PreviewProvider {
    static var previews: some View {
        AmeenWelcomeCard()
            .padding()
    }
}
