import Flutter
import SCSDKCreativeKit
import UIKit

let methodChannelName = "plugins.mintinglabs.com/snapkit_flutter_ios"

public class SnapkitFlutterIosPlugin: NSObject, FlutterPlugin {
    lazy var _snapAPI = SCSDKSnapAPI()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: methodChannelName,
            binaryMessenger: registrar.messenger()
        )
        let instance = SnapkitFlutterIosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "send":
            let args = call.arguments as! [String: Any]
            var sticker: SCSDKSnapSticker?
            if let stickerJson = args["sticker"] as? [String: Any] {
                let filePath = stickerJson["filePath"] as! String
                let isAnimated = stickerJson["isAnimated"] as! Bool
                let posX = stickerJson["posX"] as! Double
                let posY = stickerJson["posY"] as! Double
                let width = stickerJson["width"] as! Double
                let height = stickerJson["height"] as! Double
                let rotation = stickerJson["rotation"] as! Double
                
                let url = URL(fileURLWithPath: filePath, isDirectory: false)
                sticker = SCSDKSnapSticker(stickerUrl: url, isAnimated: isAnimated)
                
                sticker!.posX = posX
                sticker!.posY = posY
                sticker!.width = width
                sticker!.height = height
                sticker!.rotation = rotation
            }
            
            send(
                result: result,
                mediaType: args["mediaType"] as! String,
                filePath: args["filePath"] as? String,
                sticker: sticker,
                attachmentUrl: args["attachmentUrl"] as? String,
                caption: args["caption"] as? String
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func send(
        result: @escaping FlutterResult,
        mediaType: String,
        filePath: String?,
        sticker: SCSDKSnapSticker?,
        attachmentUrl: String?,
        caption: String?
    ) {
        let content: SCSDKSnapContent
        
        switch (mediaType) {
        case "photo":
            let url = URL(fileURLWithPath: filePath!, isDirectory: false)
            let photo = SCSDKSnapPhoto(imageUrl: url)
            content = SCSDKPhotoSnapContent(snapPhoto: photo)
        case "video":
            let url = URL(fileURLWithPath: filePath!, isDirectory: false)
            let photo = SCSDKSnapVideo(videoUrl: url)
            content = SCSDKVideoSnapContent(snapVideo: photo)
        case "none":
            content = SCSDKNoSnapContent()
        default:
            result(FlutterError(code: "SendMediaSendError", message: "Could not resolve mediaType", details: mediaType))
            return
        }
        
        content.sticker = sticker
        content.attachmentUrl = attachmentUrl
        content.caption = caption
        
        _snapAPI.startSending(content) {(error: Error?) in
            if (error != nil) {
                result(FlutterError(
                    code: "SendMediaSendError",
                    message: error?.localizedDescription,
                    details: nil)
                )
            } else {
                result(nil)
            }
        }
    }
}
