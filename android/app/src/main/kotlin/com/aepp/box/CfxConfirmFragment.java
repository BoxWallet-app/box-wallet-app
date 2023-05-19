//package com.aepp.box;
//
//import android.content.DialogInterface;
//import android.graphics.Color;
//import android.graphics.drawable.ColorDrawable;
//import android.os.Bundle;
//import android.view.Gravity;
//import android.view.KeyEvent;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//import android.view.Window;
//import android.view.WindowManager;
//import android.widget.ImageView;
//import android.widget.LinearLayout;
//import android.widget.TextView;
//
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
//public class CfxConfirmFragment extends DialogFragment {
//    private final static    String             ShareDialog_TAG = "ShareDialog";
//
//    private View         contentView;
//    private View    ivClose;
//    private TextView     tvFrom;
//    private TextView     tvTo;
//    private TextView     tvValue;
//    private TextView     tvGas;
//    private TextView     tvData;
//    private LinearLayout llBottom;
//    private TextView     ivConfirm;
//    private String       from;
//    private String       to;
//    private String       value;
//    private String       gas;
//    private String       data;
//
//
//    public CfxConfirmFragment(String from, String to, String value, String gas, String data) {
//
//        this.from = from;
//        this.to = to;
//        this.value = value;
//        this.gas = gas;
//        this.data = data;
//    }
//
//    public void setOnCfxConfirmListener(OnCfxConfirmListener onCfxConfirmListener) {
//        this.onCfxConfirmListener = onCfxConfirmListener;
//    }
//
//    private OnCfxConfirmListener onCfxConfirmListener;
//
//
//
//
//    @Nullable
//    @Override
//    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
//        //设置dialog的基本样式参数
//        initDialog();
//        if("cn".equals(CfxWebViewActivity.language)){
//            contentView = inflater.inflate(R.layout.fragment_cfx_confirm, container, false);
//        }else{
//            contentView = inflater.inflate(R.layout.fragment_cfx_confirm_en, container, false);
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
//                    onCfxConfirmListener.onConfirm();
//                dismiss();
//            }
//        });
//        updateUI();
//    }
//
//    public void updateUI() {
//        tvFrom.setText(from);
//        tvTo.setText(to);
//        tvValue.setText(value);
//        tvGas.setText(gas);
//        tvData.setText(data);
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
//        tvFrom = (TextView) contentView.findViewById(R.id.tv_from);
//        tvTo = (TextView) contentView.findViewById(R.id.tv_to);
//        tvValue = (TextView) contentView.findViewById(R.id.tv_value);
//        tvGas = (TextView) contentView.findViewById(R.id.tv_gas);
//        tvData = (TextView) contentView.findViewById(R.id.tv_data);
//        llBottom = (LinearLayout) contentView.findViewById(R.id.ll_bottom);
//        ivConfirm = (TextView) contentView.findViewById(R.id.iv_confirm);
//    }
//
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
//        lp.gravity = Gravity.BOTTOM;
//        //设置dialog的动画
//        lp.windowAnimations = R.style.BottomToTopAnim;
//        window.setAttributes(lp);
//        window.setBackgroundDrawable(new ColorDrawable());
//    }
//
//    public interface OnCfxConfirmListener {
//        void onClose();
//
//        void onConfirm();
//    }
//}
