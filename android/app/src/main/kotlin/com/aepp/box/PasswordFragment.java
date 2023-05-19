//package com.aepp.box;
//
//import android.app.Activity;
//import android.content.Context;
//import android.content.DialogInterface;
//import android.graphics.Color;
//import android.graphics.drawable.ColorDrawable;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Message;
//import android.view.Gravity;
//import android.view.KeyEvent;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//import android.view.Window;
//import android.view.WindowManager;
//import android.view.inputmethod.InputMethodManager;
//import android.widget.EditText;
//import android.widget.ImageView;
//import android.widget.LinearLayout;
//import android.widget.TextView;
//
//import androidx.annotation.NonNull;
//import androidx.annotation.Nullable;
//import androidx.fragment.app.DialogFragment;
//import androidx.fragment.app.FragmentManager;
//
//
///**
// * @author sunbaixin QQ:283122529
// * @name pep-read-sdk-android
// * @class name：com.rjsz.frame.diandu.view
// * @class describe
// * @time 6/9/21 4:59 PM
// * @change
// * @chang time
// * @class describe
// */
//public class PasswordFragment extends DialogFragment {
//    private final static String ShareDialog_TAG = "ShareDialog";
//
//    private View contentView;
//    private View ivClose;
//
//    private TextView ivConfirm;
//    private EditText etPassword;
//
//
//    public void setOnCfxConfirmListener(OnCfxConfirmListener onCfxConfirmListener) {
//        this.onCfxConfirmListener = onCfxConfirmListener;
//    }
//
//    private OnCfxConfirmListener onCfxConfirmListener;
//
//
//    @Nullable
//    @Override
//    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
//        //设置dialog的基本样式参数
//        initDialog();
//        if("cn".equals(CfxWebViewActivity.language)){
//            contentView = inflater.inflate(R.layout.fragment_password, container, false);
//        }else{
//            contentView = inflater.inflate(R.layout.fragment_password_en, container, false);
//        }
//
//        getDialog().getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
//        initView();
//        initData();
//        return contentView;
//    }
//
//
//    private void initData() {
//        ivClose.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                if (onCfxConfirmListener != null)
//                    onCfxConfirmListener.onClose();
//                dismiss();
//            }
//        });
//        ivConfirm.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                if (onCfxConfirmListener != null)
//                    onCfxConfirmListener.onConfirm(etPassword.getText().toString().trim());
//                dismiss();
//            }
//        });
//        contentView.findViewById(R.id.base).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//
//            }
//        });
//        updateUI();
//    }
//
//    public void updateUI() {
//
//    }
//
//
//    @Override
//    public void onStart() {
//        super.onStart();
//    }
//
//    public void show(FragmentManager fragmentManager) {
//        show(fragmentManager, ShareDialog_TAG);
//    }
//
//    private void initView() {
//
//        ivClose = (View) contentView.findViewById(R.id.iv_close);
//
//        ivConfirm = (TextView) contentView.findViewById(R.id.iv_confirm);
//        etPassword = (EditText) contentView.findViewById(R.id.et_password);
//        new Handler().postDelayed(new Runnable() {
//            public void run() {
//                if (getActivity() == null) {
//                    return;
//                }
//                etPassword.requestFocus();
//                InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
//                imm.showSoftInput(etPassword, InputMethodManager.SHOW_IMPLICIT);
//            }
//        }, 100);   //0.1秒
//
//
//    }
//
//    /**
//     * EditText获取焦点并显示软键盘
//     */
//    public static void showSoftInputFromWindow(Activity activity, EditText editText) {
//        if (activity == null) {
//            return;
//        }
//        editText.setFocusable(true);
//        editText.setFocusableInTouchMode(true);
//        editText.requestFocus();
////        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
//    }
//
//    private void initDialog() {
//        this.getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
//        this.getDialog().setCanceledOnTouchOutside(false);
//        this.getDialog().setCancelable(false);
//        this.getDialog().setOnKeyListener(new DialogInterface.OnKeyListener() {
//            @Override
//            public boolean onKey(DialogInterface anInterface, int keyCode, KeyEvent event) {
//                if (keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_DOWN) {
//                    return true;
//                }
//                return false;
//            }
//        });
//        Window window = this.getDialog().getWindow();
//        //去掉dialog默认的padding
//        window.getDecorView().setPadding(0, 0, 0, 0);
//        WindowManager.LayoutParams lp = window.getAttributes();
//        lp.width = WindowManager.LayoutParams.MATCH_PARENT;
//        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
//        //设置dialog的位置在底部
//        lp.gravity = Gravity.CENTER;
//        //设置dialog的动画
//        lp.windowAnimations = R.style.BottomToTopAnim;
//        window.setAttributes(lp);
//        window.setBackgroundDrawable(new ColorDrawable());
//    }
//
//    public interface OnCfxConfirmListener {
//        void onClose();
//
//        void onConfirm(String password);
//    }
//}
