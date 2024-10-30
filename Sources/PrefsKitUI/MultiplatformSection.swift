//
//  MultiplatformSection.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-29.
//

import SwiftUI

/// `Section` SwiftUI view wrapper that incorporates footer content idiomatically foe each platform.
///
/// - On macOS, the footer content is combined into the form content.
/// - On iOS, the footer content is attached below the form content.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct MultiplatformSection<Content: View, Footer: View>: View {
    public let content: () -> Content
    public let footer: () -> Footer
    
    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.content = content
        self.footer = footer
    }
    
    public var body: some View {
        #if os(macOS)
        Section {
            VStack {
                content()
                SectionFooterView {
                    footer()
                }
                .foregroundColor(.secondary)
            }
        }
        #else
        Section {
            content()
        } footer: {
            SectionFooterView {
                footer()
            }
        }
        #endif
    }
}
