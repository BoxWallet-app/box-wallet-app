package com.aepp.box

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.umeng.analytics.MobclickAgent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        GeneratedPluginRegistrant.registerWith(this)
        UmengSdkPlugin.setContext(this)
        Log.i("UMLog", "onCreate@MainActivity")
    }

    override fun onPause() {
        super.onPause()
        MobclickAgent.onPause(this)
        Log.i("UMLog", "onPause@MainActivity")
    }

    override fun onResume() {
        super.onResume()
        MobclickAgent.onResume(this)
        Log.i("UMLog", "onResume@MainActivity")
    }

    private val CHANNEL = "BOX_DART_TO_NAV"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        engine = flutterEngine;
//        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "jumpToActivity") {
                val url = call.argument<String>("url")
                val address = call.argument<String>("address")
                val language = call.argument<String>("language")
                val signingKey = call.argument<String>("signingKey")

                // 跳转
                val intent = Intent(this@MainActivity, FirstActivity::class.java)
                intent.putExtra("url", url)
                intent.putExtra("address", address)
                intent.putExtra("language", language)
                intent.putExtra("signingKey", signingKey)
                startActivity(intent)
                result.success("sucess")
            } else if (call.method == "getGasCFX") {
                val it = Intent()
                it.action = "BOX_DART_TO_NAV"


                val type = call.argument<String>("type")
                val from = call.argument<String>("from")
                val to = call.argument<String>("to")
                val value = call.argument<String>("value")
                val gas = call.argument<String>("gas")
                val data = call.argument<String>("data")

                it.putExtra("type", type)
                it.putExtra("from", from)
                it.putExtra("to", to)
                it.putExtra("value", value)
                it.putExtra("gas", gas)
                it.putExtra("data", data)
                sendBroadcast(it)


            } else if (call.method == "signTransaction") {
                val it = Intent()
                it.action = "BOX_DART_TO_NAV"


                val type = call.argument<String>("type")
                val data = call.argument<String>("data")

                it.putExtra("type", type)
                it.putExtra("data", data)
                sendBroadcast(it)


            } else if (call.method == "signTransactionError") {
                val it = Intent()
                it.action = "BOX_DART_TO_NAV"


                val type = call.argument<String>("type")
                val data = call.argument<String>("data")

                it.putExtra("type", type)
                it.putExtra("data", data)
                sendBroadcast(it)


            } else {
                result.notImplemented()
            }
        }

    }

    companion object instance {

        public lateinit var engine: FlutterEngine;

    }

}
