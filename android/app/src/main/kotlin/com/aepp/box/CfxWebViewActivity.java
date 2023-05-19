//package com.aepp.box;
//
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.IntentFilter;
//import android.graphics.Bitmap;
//import android.net.http.SslError;
//import android.os.Build;
//import android.os.Bundle;
//import android.text.TextUtils;
//import android.view.KeyEvent;
//import android.view.View;
//import android.view.Window;
//import android.webkit.JavascriptInterface;
//import android.webkit.SslErrorHandler;
//import android.webkit.ValueCallback;
//import android.webkit.WebChromeClient;
//import android.webkit.WebSettings;
//import android.webkit.WebView;
//import android.webkit.WebViewClient;
//import android.widget.ProgressBar;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import androidx.annotation.Nullable;
//import androidx.fragment.app.FragmentActivity;
//
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.io.ByteArrayOutputStream;
//import java.io.IOException;
//import java.io.InputStream;
//
//import io.flutter.plugin.common.MethodChannel;
//
///**
// * @author sunbaixin QQ:283122529
// * @name android
// * @class name：com.aepp.box
// * @class describe
// * @time 2021/8/9 3:36 下午
// * @change
// * @chang time
// * @class describe
// */
//public class CfxWebViewActivity extends FragmentActivity {
//    public static final String              CFX_WEB_VIEW_ACTIVITY = "CFX_WEB_VIEW_ACTIVITY";
//    public static       String              language              = "en";
//    private             WebView             webView;
//    private             TextView            tvTitle;
//    private             ProgressBar         progressBar;
//    private             View                llClose;
//    private             MethodChannel       methodChannelToFlutter;
//    private             String              url;
//    private             String              address;
//    private             MyBroadcastReceiver mBroadcastReceiver;
//    private             String              resolver;
//
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        requestWindowFeature(Window.FEATURE_NO_TITLE);
//        super.onCreate(savedInstanceState);
//        initBroadcast();
//        if (initData()) return;
//        setContentView(R.layout.activity_webview);
//        initView();
//
//
//        initWebView();
//    }
//
//    private void initWebView() {
//        webView.getSettings().setJavaScriptEnabled(true); //支持js
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            webView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);
//        }
//        WebSettings webSettings = webView.getSettings();
//
//        webSettings.setJavaScriptEnabled(true);
//        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
//        webSettings.setCacheMode(WebSettings.LOAD_NO_CACHE);
//        webSettings.setDomStorageEnabled(true);
//        webSettings.setDatabaseEnabled(true);
//        webSettings.setAppCacheEnabled(true);
//        webSettings.setAllowFileAccess(true);
//        webSettings.setSavePassword(true);
////        webSettings.setSupportZoom(true);
////        webSettings.setBuiltInZoomControls(true);
//        webSettings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);
//        webSettings.setUseWideViewPort(true);
//        webView.addJavascriptInterface(this, "openJoyBridge");
//        webView.setWebChromeClient(new WebChromeClient() {
//            @Override
//            public void onProgressChanged(WebView view, int newProgress) {
//                if (newProgress == 100) {
//                    progressBar.setVisibility(View.GONE);//加载完网页进度条消失
//                } else {
//                    progressBar.setVisibility(View.VISIBLE);//开始加载网页时显示进度条
//                    progressBar.setProgress(newProgress);//设置进度值
//                }
//                super.onProgressChanged(view, newProgress);
//            }
//        });
//        webView.setWebViewClient(new WebViewClient() {
//            @Override
//            public boolean shouldOverrideUrlLoading(WebView view, String url) {
//                view.loadUrl(url);
//                return true;
//            }
//
//            @Override
//            public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
//                // 不要使用super，否则有些手机访问不了，因为包含了一条 handler.cancel()
//                // super.onReceivedSslError(view, handler, error);
//                // 接受所有网站的证书，忽略SSL错误，执行访问网页
//                handler.proceed();
//            }
//
//            @Override
//            public void onPageFinished(WebView view, String url) {
//                String title = view.getTitle();
//                if (!TextUtils.isEmpty(title)) {
//                    tvTitle.setText(title);
//                }
//                if (webView.canGoBack()) {
//                    llClose.setVisibility(View.VISIBLE);
//                } else {
//                    llClose.setVisibility(View.INVISIBLE);
//                }
//            }
//
//            @Override
//            public void onPageStarted(WebView view, String url, Bitmap favicon) {
//                String js = getJs();
//                webView.evaluateJavascript(js, new ValueCallback<String>() {
//                    @Override
//                    public void onReceiveValue(String value) {//js与native交互的回调函数
//                    }
//                });
//                super.onPageStarted(view, url, favicon);
//            }
//        });
//
//        webView.loadUrl(url);
//    }
//
//    private void initView() {
//        webView = findViewById(R.id.webview);
//        tvTitle = findViewById(R.id.tv_title);
//        progressBar = findViewById(R.id.progressBar);
//        View llLeft = findViewById(R.id.ll_left);
//        llLeft.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                if (webView.canGoBack()) {
//                    webView.goBack();//返回上一页面
//                } else {
//                    finish();
//                }
//            }
//        });
//        llClose = findViewById(R.id.ll_close);
//        llClose.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
//        View llRefresh = findViewById(R.id.ll_refresh);
//        llRefresh.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                webView.reload();
//
//            }
//        });
//        View llMore = findViewById(R.id.ll_more);
//        llMore.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
//    }
//
//    private boolean initData() {
//        Intent intent = getIntent();
//        if (intent == null) {
//            return true;
//        }
//        url = intent.getStringExtra("url");
//        address = intent.getStringExtra("address");
//        language = intent.getStringExtra("language");
//        methodChannelToFlutter = new MethodChannel(
//                MainActivity.engine.getDartExecutor().getBinaryMessenger(), "BOX_NAV_TO_DART"
//        );
//        return false;
//    }
//
//    private void initBroadcast() {
//        mBroadcastReceiver = new MyBroadcastReceiver();
//        IntentFilter intentFilter = new IntentFilter();
//        intentFilter.addAction("BOX_DART_TO_NAV");
//        registerReceiver(mBroadcastReceiver, intentFilter);
//    }
//
//
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        if (keyCode == KeyEvent.KEYCODE_BACK) {
//            if (webView.canGoBack()) {
//                webView.goBack();//返回上一页面
//                return true;
//            }
//        }
//        return super.onKeyDown(keyCode, event);
//    }
//
//    //接收广播
//    public class MyBroadcastReceiver extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            String type  = intent.getStringExtra("type");
//            String from  = intent.getStringExtra("from");
//            String to    = intent.getStringExtra("to");
//            String value = intent.getStringExtra("value");
//            String gas   = intent.getStringExtra("gas");
//            String data  = intent.getStringExtra("data");
//            System.out.println("type:" + type);
//            if ("getGasCFX".equals(type)) {
//                if (methodChannelToFlutter == null)
//                    return;
//
//                CfxConfirmFragment cfxConfirmFragment = new CfxConfirmFragment(from, to, value, gas, data);
//
//                cfxConfirmFragment.show(getSupportFragmentManager());
//                cfxConfirmFragment.setOnCfxConfirmListener(new CfxConfirmFragment.OnCfxConfirmListener() {
//                    @Override
//                    public void onClose() {
//                        JSONObject res = new JSONObject();
//                        try {
//                            res.put("id", resolver);
//                            res.put("jsonrpc", "2.0");
//                            String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
//                            webView.post(new Runnable() {
//                                @Override
//                                public void run() {
//                                    webView.loadUrl("javascript:" + jsStr);
//                                }
//                            });
//                        } catch (JSONException e) {
//                            e.printStackTrace();
//                        }
//                    }
//
//                    @Override
//                    public void onConfirm() {
//
//
//                        PasswordFragment passwordFragment = new PasswordFragment();
//                        passwordFragment.show(getSupportFragmentManager());
//                        passwordFragment.setOnCfxConfirmListener(new PasswordFragment.OnCfxConfirmListener() {
//                            @Override
//                            public void onClose() {
//                                JSONObject res = new JSONObject();
//                                try {
//                                    res.put("id", resolver);
//                                    res.put("jsonrpc", "2.0");
//                                    String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
//                                    webView.post(new Runnable() {
//                                        @Override
//                                        public void run() {
//                                            webView.loadUrl("javascript:" + jsStr);
//                                        }
//                                    });
//                                } catch (JSONException e) {
//                                    e.printStackTrace();
//                                }
//                            }
//
//                            @Override
//                            public void onConfirm(String password) {
//                                methodChannelToFlutter.invokeMethod("signTransaction", password, new MethodChannel.Result() {
//                                    @Override
//                                    public void success(Object o) {
//                                        System.out.println("success" + o.toString());
//                                    }
//
//                                    @Override
//                                    public void error(String s, String s1, Object o) {
//                                        System.out.println(s);
//                                        System.out.println(s1);
////                        System.out.println(o.toString());
//                                    }
//
//                                    @Override
//                                    public void notImplemented() {
//                                        System.out.println("notImplemented");
//                                    }
//                                });
//                            }
//                        });
//
//
//                    }
//                });
//
//
//            }
//            if ("signTransaction".equals(type)) {
//
//                JSONObject res = new JSONObject();
//                try {
//                    res.put("id", resolver);
//                    res.put("jsonrpc", "2.0");
//                    res.put("result", data);
//                    String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
//                    webView.post(new Runnable() {
//                        @Override
//                        public void run() {
//                            webView.loadUrl("javascript:" + jsStr);
//                        }
//                    });
//                } catch (JSONException e) {
//                    e.printStackTrace();
//                }
//
//            }
//            if ("signTransactionError".equals(type)) {
//                JSONObject res = new JSONObject();
//                try {
//                    res.put("id", resolver);
//                    res.put("jsonrpc", "2.0");
//                    String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
//                    webView.post(new Runnable() {
//                        @Override
//                        public void run() {
//                            webView.loadUrl("javascript:" + jsStr);
//                        }
//                    });
//                } catch (JSONException e) {
//                    e.printStackTrace();
//                }
//                Toast.makeText(getApplicationContext(), "密码错误", Toast.LENGTH_SHORT).show();
//            }
//            System.out.println("data:" + data);
//        }
//    }
//
//    @JavascriptInterface
//    public void postMessage(String msg) {
//        try {
//            //获取第一条账户信息`
//            String data = msg.replaceAll("conflux/", "");
//
//            JSONObject jsonObject = null;
//
//            jsonObject = new JSONObject(data);
//
//            String type = jsonObject.getString("type");
//            resolver = jsonObject.getString("resolver");
//            if ("requestAccounts".equals(type)) {
//
//                JSONObject res = new JSONObject();
//                res.put("id", resolver);
//                res.put("jsonrpc", "2.0");
//                res.put("result", address);
//                String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
//                webView.post(new Runnable() {
//                    @Override
//                    public void run() {
//                        webView.loadUrl("javascript:" + jsStr);
//                    }
//                });
//                return;
//            }
//            if ("signTransaction".equals(type)) {
//
//                webView.post(new Runnable() {
//                    @Override
//                    public void run() {
//                        if (methodChannelToFlutter != null) {
//                            methodChannelToFlutter.invokeMethod("getGasCFX", data, new MethodChannel.Result() {
//                                @Override
//                                public void success(Object o) {
//                                    System.out.println("success" + o.toString());
//
//
//                                }
//
//                                @Override
//                                public void error(String s, String s1, Object o) {
//                                    System.out.println(s);
//                                    System.out.println(s1);
//                                    System.out.println(o.toString());
//                                }
//
//                                @Override
//                                public void notImplemented() {
//                                    System.out.println("notImplemented");
//                                }
//                            });
//                        }
//
//                    }
//                });
//                return;
////                String resolver = jsonObject.getString("resolver");
////                JSONObject res = new JSONObject();
////                res.put("id", resolver);
////                res.put("jsonrpc", "2.0");
////                res.put("result", address);
////                String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
////                webView.post(new Runnable() {
////                    @Override
////                    public void run() {
////                        webView.loadUrl("javascript:" + jsStr);
////                    }
////                });
//            }
//            if ("signTypedMessage".equals(type)) {
//
//                JSONObject res = new JSONObject();
//                res.put("id", resolver);
//                res.put("jsonrpc", "2.0");
//                res.put("result", "");
//                String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
//                webView.post(new Runnable() {
//                    @Override
//                    public void run() {
//                        webView.loadUrl("javascript:" + jsStr);
//                    }
//                });
//
////                String resolver = jsonObject.getString("resolver");
////                JSONObject res = new JSONObject();
////                res.put("id", resolver);
////                res.put("jsonrpc", "2.0");
////                res.put("result", address);
////                String jsStr = "conflux.callbacks.get(" + resolver + ")(null, " + res.toString() + ");";
////                webView.post(new Runnable() {
////                    @Override
////                    public void run() {
////                        webView.loadUrl("javascript:" + jsStr);
////                    }
////                });
//            }
//
//
//        } catch (JSONException e) {
//            e.printStackTrace();
//        }
//
//    }
//
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        unregisterReceiver(mBroadcastReceiver);
//    }
//
//    @JavascriptInterface
//    public String getChainAddress(String msg) {
//        return address;
//    }
//
//    @JavascriptInterface
//    public String getChainId(String msg) {
//        return "1029";
//    }
//
//    @JavascriptInterface
//    public String getChainRpcUrl(String msg) {
//        return "https://main.confluxrpc.com";
//    }
//
//    public String getJs() {
//
//        String jsStr = "";
//        try {
//            InputStream           in       = getApplication().getAssets().open("conflux.js");
//            byte                  buff[]   = new byte[1024];
//            ByteArrayOutputStream fromFile = new ByteArrayOutputStream();
//            do {
//                int numRead = in.read(buff);
//                if (numRead <= 0) {
//                    break;
//                }
//                fromFile.write(buff, 0, numRead);
//            } while (true);
//            jsStr = fromFile.toString();
//            in.close();
//            fromFile.close();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        return jsStr;
//    }
//}
