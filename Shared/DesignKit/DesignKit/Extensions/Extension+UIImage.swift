//
//  Extension+UIImage.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import Accelerate

extension UIImage {
    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }
    public func getImageSize(_ type: DataUnits)-> String {
        guard let data = self.pngData() else {
            return ""
        }
        var size: Double = 0.0
        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        return String(format: "%.2f", size)
    }
    public func blur(size: Float) -> UIImage {
        let boxSize = size - size.truncatingRemainder(dividingBy: 2) + 1
        let image = self.cgImage
        let inProvider = image!.dataProvider
        let height = vImagePixelCount(image!.height)
        let width = vImagePixelCount(image!.width)
        let rowBytes = image!.bytesPerRow
        let inBitmapData = inProvider!.data
        let inData = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        var inBuffer = vImage_Buffer(data: inData, height: height, width: width, rowBytes: rowBytes)
        let outData = malloc(image!.bytesPerRow * image!.height)
        var outBuffer = vImage_Buffer(data: outData, height: height, width: width, rowBytes: rowBytes)
        vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: outBuffer.data, width: Int(outBuffer.width),
                                height: Int(outBuffer.height), bitsPerComponent: 8,
                                bytesPerRow: outBuffer.rowBytes,
                                space: colorSpace, bitmapInfo: image!.bitmapInfo.rawValue)
        let imageRef = context!.makeImage()!
        let bluredImage = UIImage(cgImage: imageRef)
        free(outData)
        return bluredImage
    }
    public func cropImage(toRect rect: CGRect) -> UIImage {
        let tempImage = self.cgImage!.cropping(to: rect)!
        let croppedImage: UIImage = UIImage(cgImage: tempImage)
        return croppedImage
    }
    public func cropImage(rect: CGRect, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        self.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage!
    }
    public func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rotatedImage ?? self
        }
        return self
    }
    public func colorImage(with color: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        UIGraphicsBeginImageContext(self.size)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.translateBy(x: 0, y: self.size.height)
        contextRef?.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        contextRef?.setBlendMode(CGBlendMode.normal)
        contextRef?.draw(cgImage, in: rect)
        contextRef?.setBlendMode(CGBlendMode.sourceIn)
        color.setFill()
        contextRef?.fill(rect)
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImage
    }
    public func makeTransparent() -> UIImage? {
        let image = UIImage(data: self.jpegData(compressionQuality: 1.0)!)!
        let rawImageRef: CGImage = image.cgImage!
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContext(image.size)
        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: image.size.height)
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    public func getPixelColor(of position: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(position.y)) + Int(position.x)) * 4
        let red = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let green = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let blue = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let alpha = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
