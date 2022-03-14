package com.aepp.box

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {
    //flutter -》nave
    private val channel = "BOX_DART_TO_NAV"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        //获取engine，定义成静态，用于回传值
        engine = flutterEngine
        //注册通道
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        //定义接收通道
        MethodChannel(flutterEngine.dartExecutor, channel).setMethodCallHandler { call, result ->
            when (call.method) {
//                "CfxWebViewActivity" -> {
//                    // 跳转
//                    val intent = Intent(this@MainActivity, CfxWebViewActivity::class.java)
//                    intent.putExtra("url", call.argument<String>("url"))
//                    intent.putExtra("address", call.argument<String>("address"))
//                    intent.putExtra("language", call.argument<String>("language"))
//                    intent.putExtra("signingKey", call.argument<String>("signingKey"))
//                    startActivity(intent)
//                    result.success("success")
//                }
//                "CfxGetGas" -> {
//                    val it = Intent()
//                    it.putExtra("type", call.argument<String>("type"))
//                    it.putExtra("from", call.argument<String>("from"))
//                    it.putExtra("to", call.argument<String>("to"))
//                    it.putExtra("value", call.argument<String>("value"))
//                    it.putExtra("gas", call.argument<String>("gas"))
//                    it.putExtra("data", call.argument<String>("data"))
//                    sendBroadcast(it)
//                    result.success("success")
//
//                }
//                "CfxSignTransaction" -> {
//                    val it = Intent()
//                    it.putExtra("type", call.argument<String>("type"))
//                    it.putExtra("data", call.argument<String>("data"))
//                    sendBroadcast(it)
//                    result.success("success")
//                }
//                "passwordError" -> {
//                    val it = Intent()
//                    it.putExtra("type", call.argument<String>("type"))
//                    it.putExtra("data", call.argument<String>("data"))
//                    sendBroadcast(it)
//                    result.success("success")
//                }
//                else -> {
//                    result.notImplemented()
//                }
            }
        }

    }

    companion object Instance {
        lateinit var engine: FlutterEngine;
    }

}
