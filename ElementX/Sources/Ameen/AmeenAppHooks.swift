//
// Copyright 2026 Ameen.
//
// SPDX-License-Identifier: AGPL-3.0-only.
// Please see LICENSE files in the repository root for full details.
//

import Foundation

/// Registers the Ameen branding through the hooks Element provides for forks.
extension AppHooks {
    func setUp() {
        #if IS_MAIN_APP
        registerAppSettingsHook(AmeenAppSettingsHook())
        #endif
    }
}

#if IS_MAIN_APP
/// Ameen settings: links to ameen.dz, no preset server in release, our push gateway and OAuth redirect.
struct AmeenAppSettingsHook: AppSettingsHookProtocol {
    func configure(_ appSettings: AppSettings) -> AppSettings {
        appSettings.override(accountProviders: [Self.accountProvider],
                             allowOtherAccountProviders: true,
                             hideBrandChrome: false,
                             pushGatewayBaseURL: "https://push.ameen.dz",
                             oAuthRedirectURL: URL(string: "https://ameen.dz/oauth/ios/\(InfoPlistReader.main.bundleIdentifier)")!, // swiftlint:disable:this force_unwrapping
                             oAuthClientURIPath: nil,
                             websiteURL: "https://ameen.dz",
                             logoURL: "https://ameen.dz/icone-app.png",
                             copyrightURL: "https://ameen.dz/conditions",
                             acceptableUseURL: "https://ameen.dz/conditions",
                             privacyURL: "https://ameen.dz/confidentialite",
                             encryptionURL: "https://ameen.dz/aide",
                             deviceVerificationURL: "https://ameen.dz/aide",
                             chatBackupDetailsURL: "https://ameen.dz/aide",
                             identityPinningViolationDetailsURL: "https://ameen.dz/aide",
                             historySharingDetailsURL: "https://ameen.dz/aide",
                             elementWebHosts: ["app.ameen.dz"],
                             accountProvisioningHost: "app.ameen.dz",
                             bugReportApplicationID: "ameen-ios",
                             analyticsTermsURL: nil,
                             bundledMapTilerConfiguration: appSettings.bundledMapTilerConfiguration)
        return appSettings
    }
    
    /// The only place where a server is preset: the test server, in debug builds only.
    /// Release builds start with an empty field: users type their company's domain.
    private static var accountProvider: AccountProvider {
        #if DEBUG
        .generic("essai.ameen.dz")
        #else
        .generic("")
        #endif
    }
}
#endif
