import SwiftUI

extension View {
    func widthReader(_ width: @escaping (CGFloat?) -> Void) -> some View {
        modifier(WidthReaderModifier(width: width))
    }
}

fileprivate struct WidthReaderModifier: ViewModifier {
    private struct WidthPreferenceKey: PreferenceKey {
        static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
            value = nextValue()
        }
    }

    let width: (CGFloat?) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: WidthPreferenceKey.self, value: geo.size.width)
                        .onAppear {
                            width(geo.size.width)
                        }
                }
            )
            .onPreferenceChange(WidthPreferenceKey.self) { width in
                self.width(width)
            }
    }
}
