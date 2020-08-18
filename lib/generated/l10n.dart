// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login_page_login {
    return Intl.message(
      'Login',
      name: 'login_page_login',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account`
  String get login_page_create {
    return Intl.message(
      'Create a new account',
      name: 'login_page_create',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the mnemonic phrase`
  String get account_login_page_input_mnemonic {
    return Intl.message(
      'Please enter the mnemonic phrase',
      name: 'account_login_page_input_mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic phrase is used to log in to the wallet, fill in 12 words in order, and use spaces to fill in between the words`
  String get account_login_page_input_hint {
    return Intl.message(
      'Mnemonic phrase is used to log in to the wallet, fill in 12 words in order, and use spaces to fill in between the words',
      name: 'account_login_page_input_hint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get account_login_page_conform {
    return Intl.message(
      'Confirm',
      name: 'account_login_page_conform',
      desc: '',
      args: [],
    );
  }

  /// `Set a secure password`
  String get password_widget_set_password {
    return Intl.message(
      'Set a secure password',
      name: 'password_widget_set_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter a secure password`
  String get password_widget_input_password {
    return Intl.message(
      'Enter a secure password',
      name: 'password_widget_input_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get password_widget_conform {
    return Intl.message(
      'Confirm',
      name: 'password_widget_conform',
      desc: '',
      args: [],
    );
  }

  /// `Common Functions`
  String get home_page_function {
    return Intl.message(
      'Common Functions',
      name: 'home_page_function',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get home_page_function_send {
    return Intl.message(
      'Send',
      name: 'home_page_function_send',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get home_page_function_receive {
    return Intl.message(
      'Receive',
      name: 'home_page_function_receive',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get home_page_function_names {
    return Intl.message(
      'Name',
      name: 'home_page_function_names',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get home_page_function_games {
    return Intl.message(
      'Games',
      name: 'home_page_function_games',
      desc: '',
      args: [],
    );
  }

  /// `Transaction History`
  String get home_page_transaction {
    return Intl.message(
      'Transaction History',
      name: 'home_page_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation Number`
  String get home_page_transaction_conform {
    return Intl.message(
      'Confirmation Number',
      name: 'home_page_transaction_conform',
      desc: '',
      args: [],
    );
  }

  /// `1/2 Please enter the receiving address`
  String get token_send_one_page_title {
    return Intl.message(
      '1/2 Please enter the receiving address',
      name: 'token_send_one_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get token_send_one_page_address {
    return Intl.message(
      'Address',
      name: 'token_send_one_page_address',
      desc: '',
      args: [],
    );
  }

  /// `Scan Code`
  String get token_send_one_page_qr {
    return Intl.message(
      'Scan Code',
      name: 'token_send_one_page_qr',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get token_send_one_page_next {
    return Intl.message(
      'Next',
      name: 'token_send_one_page_next',
      desc: '',
      args: [],
    );
  }

  /// `2/2 please enter the number to send`
  String get token_send_two_page_title {
    return Intl.message(
      '2/2 please enter the number to send',
      name: 'token_send_two_page_title',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get token_send_two_page_from {
    return Intl.message(
      'From',
      name: 'token_send_two_page_from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get token_send_two_page_to {
    return Intl.message(
      'To',
      name: 'token_send_two_page_to',
      desc: '',
      args: [],
    );
  }

  /// `Transfer amount`
  String get token_send_two_page_number {
    return Intl.message(
      'Transfer amount',
      name: 'token_send_two_page_number',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get token_send_two_page_all {
    return Intl.message(
      'All',
      name: 'token_send_two_page_all',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get token_send_two_page_balance {
    return Intl.message(
      'Balance',
      name: 'token_send_two_page_balance',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get token_send_two_page_conform {
    return Intl.message(
      'Confirm',
      name: 'token_send_two_page_conform',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast successful`
  String get hint_broadcast_sucess {
    return Intl.message(
      'Broadcast successful',
      name: 'hint_broadcast_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Synchronizing node information, it is estimated that the synchronization will be successful in 5 minutes`
  String get hint_broadcast_sucess_hint {
    return Intl.message(
      'Synchronizing node information, it is estimated that the synchronization will be successful in 5 minutes',
      name: 'hint_broadcast_sucess_hint',
      desc: '',
      args: [],
    );
  }

  /// `Share your address with the recipient`
  String get token_receive_page_title {
    return Intl.message(
      'Share your address with the recipient',
      name: 'token_receive_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Copy Address`
  String get token_receive_page_copy {
    return Intl.message(
      'Copy Address',
      name: 'token_receive_page_copy',
      desc: '',
      args: [],
    );
  }

  /// `Copy successful`
  String get token_receive_page_copy_sucess {
    return Intl.message(
      'Copy successful',
      name: 'token_receive_page_copy_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Domain Name System`
  String get aens_page_title {
    return Intl.message(
      'Domain Name System',
      name: 'aens_page_title',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get aens_page_title_my {
    return Intl.message(
      'My',
      name: 'aens_page_title_my',
      desc: '',
      args: [],
    );
  }

  /// `Bid now`
  String get aens_page_title_tab_1 {
    return Intl.message(
      'Bid now',
      name: 'aens_page_title_tab_1',
      desc: '',
      args: [],
    );
  }

  /// `Top Level Domain`
  String get aens_page_title_tab_2 {
    return Intl.message(
      'Top Level Domain',
      name: 'aens_page_title_tab_2',
      desc: '',
      args: [],
    );
  }

  /// `Expiration soon`
  String get aens_page_title_tab_3 {
    return Intl.message(
      'Expiration soon',
      name: 'aens_page_title_tab_3',
      desc: '',
      args: [],
    );
  }

  /// `My domain name`
  String get aens_my_page_title {
    return Intl.message(
      'My domain name',
      name: 'aens_my_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Bidding in progress`
  String get aens_my_page_title_tab_1 {
    return Intl.message(
      'Bidding in progress',
      name: 'aens_my_page_title_tab_1',
      desc: '',
      args: [],
    );
  }

  /// `Already registered`
  String get aens_my_page_title_tab_2 {
    return Intl.message(
      'Already registered',
      name: 'aens_my_page_title_tab_2',
      desc: '',
      args: [],
    );
  }

  /// `Distance expires`
  String get aens_list_page_item_time_end {
    return Intl.message(
      'Distance expires',
      name: 'aens_list_page_item_time_end',
      desc: '',
      args: [],
    );
  }

  /// `Distance end`
  String get aens_list_page_item_time_over {
    return Intl.message(
      'Distance end',
      name: 'aens_list_page_item_time_over',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get aens_list_page_item_address {
    return Intl.message(
      'Address',
      name: 'aens_list_page_item_address',
      desc: '',
      args: [],
    );
  }

  /// `Register an eternal blockchain domain name you want`
  String get aens_register_page_title {
    return Intl.message(
      'Register an eternal blockchain domain name you want',
      name: 'aens_register_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get aens_register_page_name {
    return Intl.message(
      'Name',
      name: 'aens_register_page_name',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get aens_register_page_create {
    return Intl.message(
      'Create',
      name: 'aens_register_page_create',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get aens_detail_page_name {
    return Intl.message(
      'Name',
      name: 'aens_detail_page_name',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get aens_detail_page_balance {
    return Intl.message(
      'Price',
      name: 'aens_detail_page_balance',
      desc: '',
      args: [],
    );
  }

  /// `Current Height`
  String get aens_detail_page_height {
    return Intl.message(
      'Current Height',
      name: 'aens_detail_page_height',
      desc: '',
      args: [],
    );
  }

  /// `Distance end`
  String get aens_detail_page_over {
    return Intl.message(
      'Distance end',
      name: 'aens_detail_page_over',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get aens_detail_page_owner {
    return Intl.message(
      'Owner',
      name: 'aens_detail_page_owner',
      desc: '',
      args: [],
    );
  }

  /// `Price Increase`
  String get aens_detail_page_add {
    return Intl.message(
      'Price Increase',
      name: 'aens_detail_page_add',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get aens_detail_page_update {
    return Intl.message(
      'Update',
      name: 'aens_detail_page_update',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting_page_title {
    return Intl.message(
      'Settings',
      name: 'setting_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Save mnemonic phrase`
  String get setting_page_item_save {
    return Intl.message(
      'Save mnemonic phrase',
      name: 'setting_page_item_save',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get setting_page_item_language {
    return Intl.message(
      'Language',
      name: 'setting_page_item_language',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get setting_page_item_logout {
    return Intl.message(
      'Logout',
      name: 'setting_page_item_logout',
      desc: '',
      args: [],
    );
  }

  /// `扫二维码进行付款`
  String get scan_page_content {
    return Intl.message(
      '扫二维码进行付款',
      name: 'scan_page_content',
      desc: '',
      args: [],
    );
  }

  /// `Hint`
  String get dialog_hint {
    return Intl.message(
      'Hint',
      name: 'dialog_hint',
      desc: '',
      args: [],
    );
  }

  /// `Send failed`
  String get dialog_hint_send_error {
    return Intl.message(
      'Send failed',
      name: 'dialog_hint_send_error',
      desc: '',
      args: [],
    );
  }

  /// `Update failed`
  String get dialog_hint_update_error {
    return Intl.message(
      'Update failed',
      name: 'dialog_hint_update_error',
      desc: '',
      args: [],
    );
  }

  /// `Fare increase failed`
  String get dialog_hint_add_error {
    return Intl.message(
      'Fare increase failed',
      name: 'dialog_hint_add_error',
      desc: '',
      args: [],
    );
  }

  /// `Register failed`
  String get dialog_hint_register_error {
    return Intl.message(
      'Register failed',
      name: 'dialog_hint_register_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get dialog_conform {
    return Intl.message(
      'Confirm',
      name: 'dialog_conform',
      desc: '',
      args: [],
    );
  }

  /// `Login user does not provide mnemonic backup`
  String get dialog_login_user_no_save {
    return Intl.message(
      'Login user does not provide mnemonic backup',
      name: 'dialog_login_user_no_save',
      desc: '',
      args: [],
    );
  }

  /// `Verification failed`
  String get dialog_hint_check_error {
    return Intl.message(
      'Verification failed',
      name: 'dialog_hint_check_error',
      desc: '',
      args: [],
    );
  }

  /// `The security password is incorrect`
  String get dialog_hint_check_error_content {
    return Intl.message(
      'The security password is incorrect',
      name: 'dialog_hint_check_error_content',
      desc: '',
      args: [],
    );
  }

  /// `Address Error`
  String get hint_error_address {
    return Intl.message(
      'Address Error',
      name: 'hint_error_address',
      desc: '',
      args: [],
    );
  }

  /// `No camera permission`
  String get hint_error_camera_permissions {
    return Intl.message(
      'No camera permission',
      name: 'hint_error_camera_permissions',
      desc: '',
      args: [],
    );
  }

  /// `No data yet`
  String get loading_widget_no_data {
    return Intl.message(
      'No data yet',
      name: 'loading_widget_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Network error, please confirm and try again`
  String get loading_widget_no_net {
    return Intl.message(
      'Network error, please confirm and try again',
      name: 'loading_widget_no_net',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get loading_widget_no_net_try {
    return Intl.message(
      'Retry',
      name: 'loading_widget_no_net_try',
      desc: '',
      args: [],
    );
  }

  /// `分钟`
  String get common_points {
    return Intl.message(
      '分钟',
      name: 'common_points',
      desc: '',
      args: [],
    );
  }

  /// `小时`
  String get common_hours {
    return Intl.message(
      '小时',
      name: 'common_hours',
      desc: '',
      args: [],
    );
  }

  /// `天`
  String get common_day {
    return Intl.message(
      '天',
      name: 'common_day',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'cn'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}