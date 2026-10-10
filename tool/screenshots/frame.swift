// Composes a captioned store frame around a raw app screenshot.
//
//   frame <input.png> <output.png> "<caption>" [font.ttf]
//
// (capture.sh compiles this once with `swiftc` and passes the font.)
//
// The output keeps the input's exact pixel size (App Store Connect / Play map
// each screenshot to a device slot by its resolution): NuCatch's green → teal
// gradient, a shade deeper than the app's own so the screenshot stands out,
// the caption in the app's font (Baloo Bhai 2), and the screenshot scaled down
// below it with rounded corners and a soft shadow. Same layout as the Hanoi
// Tower store frames, so the studio's listings read as one family.
import AppKit
import CoreText

let args = CommandLine.arguments
guard args.count == 4 || args.count == 5 else {
  FileHandle.standardError.write(
    "usage: frame <in.png> <out.png> <caption> [font.ttf]\n".data(using: .utf8)!)
  exit(2)
}
let (inPath, outPath, caption) = (args[1], args[2], args[3])

// Register the app font (falls back to the bold system font if missing).
if args.count == 5 {
  CTFontManagerRegisterFontsForURL(URL(fileURLWithPath: args[4]) as CFURL, .process, nil)
}

guard let shot = NSImage(contentsOfFile: inPath),
      let shotCG = shot.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
  FileHandle.standardError.write("cannot read \(inPath)\n".data(using: .utf8)!)
  exit(1)
}
let w = CGFloat(shotCG.width), h = CGFloat(shotCG.height)

guard let ctx = CGContext(
  data: nil, width: Int(w), height: Int(h), bitsPerComponent: 8, bytesPerRow: 0,
  space: CGColorSpace(name: CGColorSpace.sRGB)!,
  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { exit(1) }

// Background: the app's green (top) → teal-blue (bottom), deepened.
let top = CGColor(srgbRed: 0x1F / 255, green: 0x7A / 255, blue: 0x4C / 255, alpha: 1)
let bottom = CGColor(srgbRed: 0x17 / 255, green: 0x3D / 255, blue: 0x52 / 255, alpha: 1)
let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB),
                          colors: [top, bottom] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: h), end: CGPoint(x: 0, y: 0), options: [])

// Layout: caption band on top, screenshot below. Sizes follow the shorter
// side so phone (portrait) and tablet (landscape) frames look alike.
let unit = min(w, h)
let margin = unit * 0.06
let captionBand = h * 0.17
let maxShotH = h - captionBand - margin
let maxShotW = w - 2 * margin
let scale = min(maxShotW / w, maxShotH / h)
let shotW = w * scale, shotH = h * scale
let shotRect = CGRect(x: (w - shotW) / 2, y: margin * 0.6, width: shotW, height: shotH)
let radius = min(shotW, shotH) * 0.06

// Shadow + rounded screenshot.
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -unit * 0.01), blur: unit * 0.04,
              color: CGColor(gray: 0, alpha: 0.55))
ctx.addPath(CGPath(roundedRect: shotRect, cornerWidth: radius, cornerHeight: radius, transform: nil))
ctx.setFillColor(bottom)
ctx.fillPath()
ctx.restoreGState()
ctx.saveGState()
ctx.addPath(CGPath(roundedRect: shotRect, cornerWidth: radius, cornerHeight: radius, transform: nil))
ctx.clip()
ctx.draw(shotCG, in: shotRect)
ctx.restoreGState()

// Caption: centred, at most two lines, shrinks until it fits.
let textRect = CGRect(x: margin, y: h - captionBand + captionBand * 0.08,
                      width: w - 2 * margin, height: captionBand * 0.84)

func captionFont(_ size: CGFloat) -> NSFont {
  NSFont(name: "BalooBhai2-ExtraBold", size: size) ?? NSFont.boldSystemFont(ofSize: size)
}

func lineWidth(_ text: String, _ size: CGFloat) -> CGFloat {
  NSAttributedString(string: text, attributes: [.font: captionFont(size)]).size().width
}

// A caption too wide for one line breaks at the space that makes its two
// lines closest in width, so it never ends on a lone word ("…, turn / by
// turn"). Decided at the starting size; the shrink loop below keeps it.
var fontSize = unit * 0.075
var text = caption
if lineWidth(caption, fontSize) > textRect.width {
  let words = caption.split(separator: " ").map(String.init)
  var best: (gap: CGFloat, text: String)? = nil
  for i in 1..<max(words.count, 2) where words.count > 1 {
    let first = words[..<i].joined(separator: " ")
    let second = words[i...].joined(separator: " ")
    let gap = abs(lineWidth(first, fontSize) - lineWidth(second, fontSize))
    if best == nil || gap < best!.gap { best = (gap, first + "\n" + second) }
  }
  if let best { text = best.text }
}

var frameSetter: CTFramesetter
var attr: NSAttributedString
repeat {
  let font = captionFont(fontSize)
  let para = NSMutableParagraphStyle()
  para.alignment = .center
  para.lineHeightMultiple = 0.9
  attr = NSAttributedString(string: text, attributes: [
    .font: font,
    .foregroundColor: NSColor.white,
    .paragraphStyle: para,
  ])
  frameSetter = CTFramesetterCreateWithAttributedString(attr)
  let fit = CTFramesetterSuggestFrameSizeWithConstraints(
    frameSetter, CFRange(location: 0, length: 0), nil,
    CGSize(width: textRect.width, height: .greatestFiniteMagnitude), nil)
  if fit.height <= textRect.height { break }
  fontSize *= 0.92
} while fontSize > unit * 0.03
let fit = CTFramesetterSuggestFrameSizeWithConstraints(
  frameSetter, CFRange(location: 0, length: 0), nil,
  CGSize(width: textRect.width, height: .greatestFiniteMagnitude), nil)
// Vertically centre the text block in the caption band.
let centred = CGRect(x: textRect.minX, y: textRect.midY - fit.height / 2,
                     width: textRect.width, height: fit.height)
let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0),
                                     CGPath(rect: centred, transform: nil), nil)
CTFrameDraw(frame, ctx)

guard let out = ctx.makeImage() else { exit(1) }
let rep = NSBitmapImageRep(cgImage: out)
guard let png = rep.representation(using: .png, properties: [:]) else { exit(1) }
try! png.write(to: URL(fileURLWithPath: outPath))
