//
//  UIImageUtil.swift
//  ShinhoIOSUtils
//
//  Created by Yan Hu on 2020/9/16.
//

import UIKit

public extension UIImage {
    private static var cacheUrlKey: Void?
    /// 图片缓存文件夹
    static var imageCacheURL: URL {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
        return cachesURL.appendingPathComponent("cn.com.shinho.fsfa.imageCache")
    }
    
    var cacheUrl: String? {
        set {
            objc_setAssociatedObject(self, &Self.cacheUrlKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &Self.cacheUrlKey) as? String
        }
    }
    
    
    /// 图片右下角添加当前时间
    /// - Parameter font: 文字字体
    /// - Returns: 图片
    func dateImage(font: UIFont = .systemFont(ofSize: 18)) -> UIImage {
        let date = Date()
        let text = date.description as NSString
        let point = CGPoint.init(x: 20, y: self.size.height - 40)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0);
        self.draw(in: CGRect.init(origin: .zero, size: self.size))
        text.draw(at: point, withAttributes: [NSAttributedString.Key.font: font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    
    /// 默认渐变图片
    static var defaultGradiantImage: UIImage? {
        return gradiantImage(leftColor: .leftGradientColor, rightColor: .rightGradientColor)
    }
    
    /// 渐变图片
    /// - Parameters:
    ///   - leftColor: 左侧颜色
    ///   - rightColor: 右侧颜色
    /// - Returns: 图片
    static func gradiantImage(leftColor: UIColor, rightColor: UIColor) -> UIImage? {
        let size = CGSize(width: 2.0, height: 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(size.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [leftColor.cgColor, rightColor.cgColor]
        let locations: [CGFloat] = [0.0, 1.0]
        let gradientOpt = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        guard let gradient = gradientOpt else { return nil }
        context?.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x:size.width, y:0), options: .drawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// 缓存这张图片到本地
    /// - Returns: 本地 path
    func cacheLocal() -> String {
        // 如果存在这个缓存, 则直接返回缓存的 path
        if let path = cacheUrl, let temp = URL(string: path), temp.isFileURL {
            let newUrl = UIImage.imageCacheURL.appendingPathComponent(temp.lastPathComponent, isDirectory: false)
            if FileManager.default.fileExists(atPath: newUrl.path) {
                return newUrl.absoluteString
            }
        }
        
        let name = NSUUID().uuidString
        let url = UIImage.imageCacheURL.appendingPathComponent(name, isDirectory: false).appendingPathExtension("jpg")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: UIImage.imageCacheURL.path) {
            do {
                try fileManager.createDirectory(atPath: UIImage.imageCacheURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch _ {}
        }
        
        var cached = false
        let data = jpegData(compressionQuality: 0.9)
        if fileManager.createFile(atPath: url.path, contents: data, attributes: [:]) {
            cached = true
        } else {
            do {
                try data?.write(to: url)
                cached = true
            } catch {
                assert(false, "图片写入本地失败")
            }
        }
        
        if !cached {
            cacheUrl = nil
            return ""
        }
        
        cacheUrl = url.absoluteString
        return cacheUrl!
    }
    
    
    /// 读取本地图片
    /// - Parameter fileUrl: 图片 URL
    /// - Returns: 图片
    static func localImage(fileUrl: String?) -> UIImage? {
        guard let urlString = fileUrl, let url = URL(string: urlString), url.isFileURL else { return nil }
        let realUrl = UIImage.imageCacheURL.appendingPathComponent(url.lastPathComponent, isDirectory: false)
        let image = UIImage.init(contentsOfFile: realUrl.path)
        if image == nil {
            assert(false, "读取本地图片失败")
        }
        return image
    }
    
    
    /// base64 to UIImage
    /// - Parameter base64: base64 string
    /// - Returns: UIImage
    static func image(with base64: String) -> UIImage? {
        var str = base64
        if str.hasPrefix("data:image") {
            guard let newBase64String = str.components(separatedBy: ",").last else {
                return nil
            }
            str = newBase64String
        }
        
        guard let data = Data.init(base64Encoded: str) else { return nil }
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
    
    
    /// 检测 超过 expiredDate 时间没有访问图片的地址
    /// - Returns: 过期图片的地址列表
    fileprivate class func travelCachedFiles() -> [URL] {
        
        let diskCacheURL = UIImage.imageCacheURL
        let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey, .contentAccessDateKey, .totalFileAllocatedSizeKey]
        let expiredDate = Date(timeIntervalSinceNow: -30 * 24 * 60 * 60)
        
        var urlsToDelete = [URL]()
        
        let fileManager = FileManager.default
        for fileUrl in (try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)) ?? [] {
            
            do {
                let resourceValues = try fileUrl.resourceValues(forKeys: resourceKeys)
                // If it is a Directory. Continue to next file URL.
                if resourceValues.isDirectory == true {
                    continue
                }
                
                // If this file is expired, add it to URLsToDelete
                if let lastAccessData = resourceValues.contentAccessDate,
                    (lastAccessData as NSDate).laterDate(expiredDate) <= expiredDate {
                    
                    if fileUrl.absoluteString.contains(".jpg") {
                        urlsToDelete.append(fileUrl)
                    }
                    continue
                }
            } catch _ { }
        }
        
        return urlsToDelete
    }
    
    
    /// 重设图片大小
    /// - Parameter reSize: 目标大小
    /// - Returns: UIImage
    func reSizeImage(reSize: CGSize) -> UIImage {
        if reSize == size {
            return fixOrientation()
        }
        var reSizeImage: UIImage?
        autoreleasepool {
            UIGraphicsBeginImageContextWithOptions(reSize, false, scale) // 保持图片原来的scale
            draw(in: CGRect.init(origin: .zero, size: reSize));
            reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        return reSizeImage ?? UIImage()
    }
    
    
    /// 等比率缩放
    /// - Parameter scaleSize: 比例
    /// - Returns: UIImage
    func scaleImage(scaleSize: CGFloat) -> UIImage {
        let reSize = CGSize.init(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    
    /// SFA 默认缩放大小
    var resizeImage: UIImage {
        let minSize: CGFloat = 1280
        let height = self.size.height * self.scale
        let width = self.size.width * self.scale
        let scale = minSize/max(min(height, width), minSize)
        return self.scaleImage(scaleSize: scale)
    }
    /// SFA 判断缩放比例, 默认根据 1500 * 2000
    var shouldScale: CGFloat {
        return  size.width * size.height / (1500 * 2000)
    }
    
    
    /// 多张图片拼接
    /// - Parameters:
    ///   - imageArray: 待拼接图片列表
    ///   - row: 几行
    /// - Returns: 拼接后图片
    static func drawImages(imageArray: [UIImage], row: Int = 1) -> UIImage {
        if imageArray.count == 0 { return UIImage() }
        var drawImage: UIImage?
        autoreleasepool {
            var width: CGFloat = 0
            var height = imageArray.first?.size.height ?? 1
            
            var i = 0
            for image in imageArray {
                if i % row == 0 {
                    width +=  height / image.size.height * image.size.width
                }
                i += 1
            }
            let remainder = imageArray.count % row
            if remainder != 0 {
                let image = imageArray[imageArray.count - remainder]
                width +=  height / image.size.height * image.size.width
            }
            
            if width > 10000 {
                height = height * (10000 / width)
                width = 10000
            }
            
            let totalHeight = height * row.cgFloat
            UIGraphicsBeginImageContext(CGSize(width: width, height: totalHeight))
            var imageX: CGFloat = 0
            
            var index = 0
            var currentRow = 0
            var maxWidth: CGFloat = 0
            for image in imageArray {
                autoreleasepool {
                    if currentRow != index % row {
                        maxWidth = 0
                    }
                    currentRow = index % row
                    let reSize = CGSize.init(width: height / image.size.height * image.size.width, height: height)
                    image.draw(in: CGRect.init(origin: CGPoint(x: imageX, y: height * currentRow.cgFloat), size: reSize));
                    let w = height / image.size.height * image.size.width
                    if w > maxWidth {
                        maxWidth = w
                    }
                    if index % row == row - 1 {
                        imageX += maxWidth
                    }
                    index += 1
                }
            }
            
            drawImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return drawImage ?? UIImage()
    }
    
    
    /// 调整图片方向
    /// - Returns: UIImage
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        guard let cgImage = self.cgImage else { return self }
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            break
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        transform = transform.scaledBy(x: scale, y: scale)
        
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch imageOrientation {
        case .left,.leftMirrored,.rightMirrored,.right:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width:size.height, height: size.width))
            break
        default:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width:size.width, height: size.height))
        }
        if let cgimg = ctx?.makeImage() {
            let img = UIImage.init(cgImage: cgimg)
            return img
        }
        return self
    }
    
    
    /// 远点图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - diameter: 直径
    /// - Returns: 图片
    static func circlePoint(color: UIColor, diameter: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fillEllipse(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

