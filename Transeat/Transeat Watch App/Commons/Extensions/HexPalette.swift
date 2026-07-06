import SwiftUI

struct HexPalette {
    let cherry100 = Color(hex: "#FDEAF1")
    let cherry200 = Color(hex: "#FBC4D5")
    let cherry300 = Color(hex: "#F99EB9")
    let cherry400 = Color(hex: "#BC5875")
    let cherry500 = Color(hex: "#7F1230")
    let cherry600 = Color(hex: "#650C24")
    let cherry700 = Color(hex: "#4B0518")
    let cherry800 = Color(hex: "#400312")
    let cherry900 = Color(hex: "#35000B")
    
    let white = Color(hex: "#F2F2F2")
    let lightgray = Color(hex: "#E5E5EA")
    let gray = Color(hex: "#C7C7CC")
    let darkgray = Color(hex: "#76767D")
    let black = Color(hex: "#000000")
    
    let danger = Color(hex: "#FF5F57")
    let warning = Color(hex: "#FEBC2F")
    let success = Color(hex: "#27C840")
}

extension ShapeStyle where Self == Color {
    static var hexPalette: HexPalette { HexPalette() }
}

extension Color {
    static var hexPalette: HexPalette { HexPalette() }
}

// Supporting Hex Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
