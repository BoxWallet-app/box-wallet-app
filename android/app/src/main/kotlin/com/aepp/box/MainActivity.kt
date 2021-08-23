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

    private val CHANNEL = "plugin_demo"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        engine = flutterEngine;
//        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "jumpToActivity") {
                // 参数
                val params = call.argument<String>("key")

                // 跳转
                val intent = Intent(this@MainActivity, FirstActivity::class.java)
                intent.putExtra("activityKey", params)
                startActivity(intent)
                result.success(params)
            } else {
                result.notImplemented()
            }
        }

    }
    companion object instance {

        public lateinit var engine: FlutterEngine;

    }

}
