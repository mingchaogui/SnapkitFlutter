package com.mintinglabs.snapkit_flutter_android

import com.snap.corekit.SnapKit
import com.snap.creativekit.SnapCreative
import com.snap.creativekit.api.SnapCreativeKitApi
import com.snap.creativekit.media.SnapMediaFactory
import com.snap.creativekit.media.SnapPhotoFile
import com.snap.creativekit.media.SnapSticker
import com.snap.creativekit.media.SnapVideoFile
import com.snap.creativekit.models.SnapContent
import com.snap.creativekit.models.SnapLiveCameraContent
import com.snap.creativekit.models.SnapPhotoContent
import com.snap.creativekit.models.SnapVideoContent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/** SnapkitFlutterAndroidPlugin */
class SnapkitFlutterAndroidPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        const val METHOD_CHANNEL = "plugins.mintinglabs.com/snapkit_flutter_android"
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var creativeKitApi: SnapCreativeKitApi
    private lateinit var mediaFactory: SnapMediaFactory

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
        channel.setMethodCallHandler(this)
        SnapKit.initSDK(flutterPluginBinding.applicationContext)
        creativeKitApi = SnapCreative.getApi(flutterPluginBinding.applicationContext)
        mediaFactory = SnapCreative.getMediaFactory(flutterPluginBinding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        SnapKit.deInitialize()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "send" -> {
                val sticker: SnapSticker?
                try {
                    val stickerJson = call.argument<Map<String, Any>>("sticker")
                    sticker = if (stickerJson != null) {
                        val filePath = stickerJson["filePath"] as String
                        val posX = stickerJson["posX"] as Double
                        val posY = stickerJson["posY"] as Double
                        val widthDp = stickerJson["width"] as Double
                        val heightDp = stickerJson["height"] as Double
                        val rotation = stickerJson["rotation"] as Double

                        mediaFactory.getSnapStickerFromFile(File(filePath)).apply {
                            setPosX(posX.toFloat())
                            setPosY(posY.toFloat())
                            setWidthDp(widthDp.toFloat())
                            setHeightDp(heightDp.toFloat())
                            setRotationDegreesClockwise(rotation.toFloat())
                        }
                    } else {
                        null
                    }
                } catch (e: Exception) {
                    result.error("SendMediaError", e.localizedMessage, e)
                    return
                }

                send(
                    result,
                    call.argument<String>("mediaType")!!,
                    call.argument<String>("filePath"),
                    sticker,
                    call.argument<String>("attachmentUrl"),
                    call.argument<String>("caption"),
                )
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun send(
        result: Result,
        mediaType: String,
        filePath: String?,
        sticker: SnapSticker?,
        attachmentUrl: String?,
        caption: String?,
    ) {
        val content: SnapContent
        try {
            when (mediaType) {
                "photo" -> {
                    val file = File(filePath!!)
                    val photoFile: SnapPhotoFile = mediaFactory.getSnapPhotoFromFile(file)
                    content = SnapPhotoContent(photoFile)
                }

                "video" -> {
                    val file = File(filePath!!)
                    val videoFile: SnapVideoFile = mediaFactory.getSnapVideoFromFile(file)
                    content = SnapVideoContent(videoFile)
                }

                "none" -> {
                    content = SnapLiveCameraContent()
                }

                else -> {
                    result.error(
                        "SendMediaError",
                        "Could not resolve mediaType",
                        mediaType
                    )
                    return
                }
            }

            content.also {
                it.snapSticker = sticker
                it.attachmentUrl = attachmentUrl
                it.captionText = caption
            }

            creativeKitApi.send(content)
            result.success(null)
        } catch (e: Exception) {
            result.error("SendMediaError", e.localizedMessage, e)
        }
    }
}
