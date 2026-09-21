package com.echo.orchestrator.echo_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.echo.orchestrator/native_device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceHardwareProfile" -> {
                    val profile = mapOf(
                        "device" to android.os.Build.MODEL,
                        "manufacturer" to android.os.Build.MANUFACTURER,
                        "hardware" to android.os.Build.HARDWARE,
                        "androidVersion" to android.os.Build.VERSION.RELEASE,
                        "npuAccelerated" to true,
                        "supportedRuntimes" to listOf("ONNX", "GGUF", "NNAPI", "TFLite")
                    )
                    result.success(profile)
                }
                "checkOfficeKitStatus" -> {
                    val status = mapOf(
                        "connected" to true,
                        "bridgeProtocol" to "OFFICE_KIT_V1",
                        "clipboardSyncReady" to true
                    )
                    result.success(status)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
