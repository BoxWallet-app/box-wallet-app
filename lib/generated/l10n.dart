// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

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

  /// `Get started`
  String get login_page_login {
    return Intl.message(
      'Get started',
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

  /// `Enter the seed phrase`
  String get account_login_page_input_mnemonic {
    return Intl.message(
      'Enter the seed phrase',
      name: 'account_login_page_input_mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `The seed phrase (or mnemonic phrase) is used for logging in to your wallet. Fill in 12 words in order, and type spaces between the words.`
  String get account_login_page_input_hint {
    return Intl.message(
      'The seed phrase (or mnemonic phrase) is used for logging in to your wallet. Fill in 12 words in order, and type spaces between the words.',
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

  /// `Set a security password`
  String get password_widget_set_password {
    return Intl.message(
      'Set a security password',
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

  /// `My Assets`
  String get home_page_my_count {
    return Intl.message(
      'My Assets',
      name: 'home_page_my_count',
      desc: '',
      args: [],
    );
  }

  /// `Defi`
  String get home_page_function_defi {
    return Intl.message(
      'Defi',
      name: 'home_page_function_defi',
      desc: '',
      args: [],
    );
  }

  /// `GO`
  String get home_page_function_defi_go {
    return Intl.message(
      'GO',
      name: 'home_page_function_defi_go',
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

  /// `Name System`
  String get home_page_function_names {
    return Intl.message(
      'Name System',
      name: 'home_page_function_names',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get home_page_function_name {
    return Intl.message(
      'Name',
      name: 'home_page_function_name',
      desc: '',
      args: [],
    );
  }

  /// `Burning`
  String get home_page_function_name_count {
    return Intl.message(
      'Burning',
      name: 'home_page_function_name_count',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get home_page_function_name_count_number {
    return Intl.message(
      '',
      name: 'home_page_function_name_count_number',
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

  /// `Transaction`
  String get home_page_transaction {
    return Intl.message(
      'Transaction',
      name: 'home_page_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get home_page_transaction_conform {
    return Intl.message(
      'Confirmation',
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

  /// `Transfer Coin`
  String get token_send_two_page_coin {
    return Intl.message(
      'Transfer Coin',
      name: 'token_send_two_page_coin',
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

  /// `Copy`
  String get token_receive_page_copy {
    return Intl.message(
      'Copy',
      name: 'token_receive_page_copy',
      desc: '',
      args: [],
    );
  }

  /// `Successful`
  String get token_receive_page_copy_sucess {
    return Intl.message(
      'Successful',
      name: 'token_receive_page_copy_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Name System`
  String get aens_page_title {
    return Intl.message(
      'Name System',
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

  /// `Register`
  String get aens_page_title_tab_1 {
    return Intl.message(
      'Register',
      name: 'aens_page_title_tab_1',
      desc: '',
      args: [],
    );
  }

  /// `Top Price`
  String get aens_page_title_tab_2 {
    return Intl.message(
      'Top Price',
      name: 'aens_page_title_tab_2',
      desc: '',
      args: [],
    );
  }

  /// `Expiration`
  String get aens_page_title_tab_3 {
    return Intl.message(
      'Expiration',
      name: 'aens_page_title_tab_3',
      desc: '',
      args: [],
    );
  }

  /// `My Name`
  String get aens_my_page_title {
    return Intl.message(
      'My Name',
      name: 'aens_my_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get aens_my_page_title_tab_1 {
    return Intl.message(
      'Register',
      name: 'aens_my_page_title_tab_1',
      desc: '',
      args: [],
    );
  }

  /// `Registered`
  String get aens_my_page_title_tab_2 {
    return Intl.message(
      'Registered',
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

  /// `address`
  String get aens_list_page_item_address {
    return Intl.message(
      'address',
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

  /// `Register`
  String get aens_detail_page_add {
    return Intl.message(
      'Register',
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

  /// `Version`
  String get setting_page_item_version {
    return Intl.message(
      'Version',
      name: 'setting_page_item_version',
      desc: '',
      args: [],
    );
  }

  /// `Rest All Data`
  String get setting_page_item_logout {
    return Intl.message(
      'Rest All Data',
      name: 'setting_page_item_logout',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get setting_page_item_share {
    return Intl.message(
      'Share',
      name: 'setting_page_item_share',
      desc: '',
      args: [],
    );
  }

  /// `Node Configuration`
  String get setting_page_node_set {
    return Intl.message(
      'Node Configuration',
      name: 'setting_page_node_set',
      desc: '',
      args: [],
    );
  }

  /// `Node Address`
  String get setting_page_node_url {
    return Intl.message(
      'Node Address',
      name: 'setting_page_node_url',
      desc: '',
      args: [],
    );
  }

  /// `Editor Address`
  String get setting_page_compiler_url {
    return Intl.message(
      'Editor Address',
      name: 'setting_page_compiler_url',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get setting_page_node_save {
    return Intl.message(
      'Save',
      name: 'setting_page_node_save',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get setting_page_node_reset {
    return Intl.message(
      'Reset',
      name: 'setting_page_node_reset',
      desc: '',
      args: [],
    );
  }

  /// `Scan the QR code`
  String get scan_page_content {
    return Intl.message(
      'Scan the QR code',
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

  /// `The mnemonic is incorrect`
  String get dialog_hint_mnemonic {
    return Intl.message(
      'The mnemonic is incorrect',
      name: 'dialog_hint_mnemonic',
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

  /// `Cancel`
  String get dialog_cancel {
    return Intl.message(
      'Cancel',
      name: 'dialog_cancel',
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

  /// `Minutes`
  String get common_points {
    return Intl.message(
      'Minutes',
      name: 'common_points',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get common_hours {
    return Intl.message(
      'Hours',
      name: 'common_hours',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get common_day {
    return Intl.message(
      'day',
      name: 'common_day',
      desc: '',
      args: [],
    );
  }

  /// `Please copy the mnemonic phrase`
  String get mnemonic_copy_title {
    return Intl.message(
      'Please copy the mnemonic phrase',
      name: 'mnemonic_copy_title',
      desc: '',
      args: [],
    );
  }

  /// `The mnemonic phrase is used to restore the wallet. Copy the following 12 words on the paper in order and save them in a safe place`
  String get mnemonic_copy_content {
    return Intl.message(
      'The mnemonic phrase is used to restore the wallet. Copy the following 12 words on the paper in order and save them in a safe place',
      name: 'mnemonic_copy_content',
      desc: '',
      args: [],
    );
  }

  /// `Don't take a screenshot!`
  String get mnemonic_copy_hint1 {
    return Intl.message(
      'Don\'t take a screenshot!',
      name: 'mnemonic_copy_hint1',
      desc: '',
      args: [],
    );
  }

  /// `If someone gets your mnemonic phrase, they will get your assets directly!`
  String get mnemonic_copy_hint2 {
    return Intl.message(
      'If someone gets your mnemonic phrase, they will get your assets directly!',
      name: 'mnemonic_copy_hint2',
      desc: '',
      args: [],
    );
  }

  /// `I have saved it safely`
  String get mnemonic_copy_confrom {
    return Intl.message(
      'I have saved it safely',
      name: 'mnemonic_copy_confrom',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the mnemonic phrase`
  String get mnemonic_confirm_title {
    return Intl.message(
      'Please confirm the mnemonic phrase',
      name: 'mnemonic_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `In order to confirm that your mnemonic phrase is copied correctly, please click the mnemonic phrase in the corresponding order`
  String get mnemonic_confirm_content {
    return Intl.message(
      'In order to confirm that your mnemonic phrase is copied correctly, please click the mnemonic phrase in the corresponding order',
      name: 'mnemonic_confirm_content',
      desc: '',
      args: [],
    );
  }

  /// `Lock AE to in mining \nEarn ABC`
  String get defi_title {
    return Intl.message(
      'Lock AE to in mining \nEarn ABC',
      name: 'defi_title',
      desc: '',
      args: [],
    );
  }

  /// `Record`
  String get defi_title_record {
    return Intl.message(
      'Record',
      name: 'defi_title_record',
      desc: '',
      args: [],
    );
  }

  /// `Total Lockup (AE)`
  String get defi_head_card_all_token {
    return Intl.message(
      'Total Lockup (AE)',
      name: 'defi_head_card_all_token',
      desc: '',
      args: [],
    );
  }

  /// `You are locked (AE)`
  String get defi_head_card_my_token {
    return Intl.message(
      'You are locked (AE)',
      name: 'defi_head_card_my_token',
      desc: '',
      args: [],
    );
  }

  /// `pledge time`
  String get defi_card_time {
    return Intl.message(
      'pledge time',
      name: 'defi_card_time',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get defi_card_time_day {
    return Intl.message(
      'Day',
      name: 'defi_card_time_day',
      desc: '',
      args: [],
    );
  }

  /// `pledge amount`
  String get defi_card_count {
    return Intl.message(
      'pledge amount',
      name: 'defi_card_count',
      desc: '',
      args: [],
    );
  }

  /// `Balance (AE)`
  String get defi_card_balance {
    return Intl.message(
      'Balance (AE)',
      name: 'defi_card_balance',
      desc: '',
      args: [],
    );
  }

  /// `The pledge`
  String get defi_card_mine {
    return Intl.message(
      'The pledge',
      name: 'defi_card_mine',
      desc: '',
      args: [],
    );
  }

  /// `Mining Rules`
  String get defi_card_hint {
    return Intl.message(
      'Mining Rules',
      name: 'defi_card_hint',
      desc: '',
      args: [],
    );
  }

  /// `The amount of pledge`
  String get defi_card_in_title_content {
    return Intl.message(
      'The amount of pledge',
      name: 'defi_card_in_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Retrieve quantity`
  String get defi_card_out_title_content {
    return Intl.message(
      'Retrieve quantity',
      name: 'defi_card_out_title_content',
      desc: '',
      args: [],
    );
  }

  /// `My Earnings (ABC)`
  String get defi_card_my_get_hint {
    return Intl.message(
      'My Earnings (ABC)',
      name: 'defi_card_my_get_hint',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get defi_card_get {
    return Intl.message(
      'Receive',
      name: 'defi_card_get',
      desc: '',
      args: [],
    );
  }

  /// `Extract`
  String get defi_card_out {
    return Intl.message(
      'Extract',
      name: 'defi_card_out',
      desc: '',
      args: [],
    );
  }

  /// `Enter the amount you want to pledge`
  String get defi_card_in_title {
    return Intl.message(
      'Enter the amount you want to pledge',
      name: 'defi_card_in_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter the amount you want to withdraw`
  String get defi_card_out_title {
    return Intl.message(
      'Enter the amount you want to withdraw',
      name: 'defi_card_out_title',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get defi_raking_1 {
    return Intl.message(
      'Rank',
      name: 'defi_raking_1',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get defi_raking_2 {
    return Intl.message(
      'Address',
      name: 'defi_raking_2',
      desc: '',
      args: [],
    );
  }

  /// `Scale`
  String get defi_raking_3 {
    return Intl.message(
      'Scale',
      name: 'defi_raking_3',
      desc: '',
      args: [],
    );
  }

  /// `Amount (ABC)`
  String get defi_raking_4 {
    return Intl.message(
      'Amount (ABC)',
      name: 'defi_raking_4',
      desc: '',
      args: [],
    );
  }

  /// `Basic introduction`
  String get defi_card_hint_base {
    return Intl.message(
      'Basic introduction',
      name: 'defi_card_hint_base',
      desc: '',
      args: [],
    );
  }

  /// `ABC is a pledge mining written based on the AE blockchain AEX9 protocol extension. The whole process is open and transparent, there is no pledge time limit, and it can be released at any time. Users can exchange ABC, ABC user BoxWallet ecological pass by staking AE. It is an important part of the ecology behind. The output speed of ABC is strongly related to the number of locked AEs. The V3 version can set the number of mapped AEs before pledge. During the mining period, the number of user wallets cannot be less than the set number of mappings . If lower than the mapped amount is found by the police (watchdog program, each block detection), you will be locked in a small black room and the income of this ABC will be confiscated, and the account cannot be used for mining ABC permanently operating. The user can unmap at any time during the mapping period. After cancellation, you can freely transfer AE`
  String get defi_card_hint_base_content {
    return Intl.message(
      'ABC is a pledge mining written based on the AE blockchain AEX9 protocol extension. The whole process is open and transparent, there is no pledge time limit, and it can be released at any time. Users can exchange ABC, ABC user BoxWallet ecological pass by staking AE. It is an important part of the ecology behind. The output speed of ABC is strongly related to the number of locked AEs. The V3 version can set the number of mapped AEs before pledge. During the mining period, the number of user wallets cannot be less than the set number of mappings . If lower than the mapped amount is found by the police (watchdog program, each block detection), you will be locked in a small black room and the income of this ABC will be confiscated, and the account cannot be used for mining ABC permanently operating. The user can unmap at any time during the mapping period. After cancellation, you can freely transfer AE',
      name: 'defi_card_hint_base_content',
      desc: '',
      args: [],
    );
  }

  /// `Period-Multiple`
  String get defi_card_hint_day {
    return Intl.message(
      'Period-Multiple',
      name: 'defi_card_hint_day',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get defi_card_hint_day_content1 {
    return Intl.message(
      'Quantity',
      name: 'defi_card_hint_day_content1',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get defi_card_hint_day_content2 {
    return Intl.message(
      'Period',
      name: 'defi_card_hint_day_content2',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get defi_card_hint_day_content3 {
    return Intl.message(
      'Income',
      name: 'defi_card_hint_day_content3',
      desc: '',
      args: [],
    );
  }

  /// `Total pledge-multiple`
  String get defi_card_hint_mine {
    return Intl.message(
      'Total pledge-multiple',
      name: 'defi_card_hint_mine',
      desc: '',
      args: [],
    );
  }

  /// `Total pledge amount (AE)`
  String get defi_card_hint_mine_content1 {
    return Intl.message(
      'Total pledge amount (AE)',
      name: 'defi_card_hint_mine_content1',
      desc: '',
      args: [],
    );
  }

  /// `Multiple`
  String get defi_card_hint_mine_content2 {
    return Intl.message(
      'Multiple',
      name: 'defi_card_hint_mine_content2',
      desc: '',
      args: [],
    );
  }

  /// `Mining output-multiple`
  String get defi_card_hint_out {
    return Intl.message(
      'Mining output-multiple',
      name: 'defi_card_hint_out',
      desc: '',
      args: [],
    );
  }

  /// `Total number of mining`
  String get defi_card_hint_out_content1 {
    return Intl.message(
      'Total number of mining',
      name: 'defi_card_hint_out_content1',
      desc: '',
      args: [],
    );
  }

  /// `Multiple`
  String get defi_card_hint_out_content2 {
    return Intl.message(
      'Multiple',
      name: 'defi_card_hint_out_content2',
      desc: '',
      args: [],
    );
  }

  /// `Issuance Algorithm`
  String get defi_card_hint_info {
    return Intl.message(
      'Issuance Algorithm',
      name: 'defi_card_hint_info',
      desc: '',
      args: [],
    );
  }

  /// `(Pledge quantity*period*period daily income* pledge multiple*mining multiple) / 1000 = income`
  String get defi_card_hint_info_content {
    return Intl.message(
      '(Pledge quantity*period*period daily income* pledge multiple*mining multiple) / 1000 = income',
      name: 'defi_card_hint_info_content',
      desc: '',
      args: [],
    );
  }

  /// `Being pledged - Old`
  String get defi_record_old_title {
    return Intl.message(
      'Being pledged - Old',
      name: 'defi_record_old_title',
      desc: '',
      args: [],
    );
  }

  /// `Being pledged`
  String get defi_record_title {
    return Intl.message(
      'Being pledged',
      name: 'defi_record_title',
      desc: '',
      args: [],
    );
  }

  /// `Old contract`
  String get defi_record_title_right {
    return Intl.message(
      'Old contract',
      name: 'defi_record_title_right',
      desc: '',
      args: [],
    );
  }

  /// `Locked position (AE)`
  String get defi_record_item_lock_number {
    return Intl.message(
      'Locked position (AE)',
      name: 'defi_record_item_lock_number',
      desc: '',
      args: [],
    );
  }

  /// `Mining Quantity (ABC)`
  String get defi_record_item_mine_number {
    return Intl.message(
      'Mining Quantity (ABC)',
      name: 'defi_record_item_mine_number',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Countdown`
  String get defi_record_item_time {
    return Intl.message(
      'Unlock Countdown',
      name: 'defi_record_item_time',
      desc: '',
      args: [],
    );
  }

  /// `Renewal countdown`
  String get defi_record_item_day_time {
    return Intl.message(
      'Renewal countdown',
      name: 'defi_record_item_day_time',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get defi_record_item_status {
    return Intl.message(
      'Status',
      name: 'defi_record_item_status',
      desc: '',
      args: [],
    );
  }

  /// `Mining`
  String get defi_record_item_status_lock {
    return Intl.message(
      'Mining',
      name: 'defi_record_item_status_lock',
      desc: '',
      args: [],
    );
  }

  /// `Renewable`
  String get defi_record_item_status_continue {
    return Intl.message(
      'Renewable',
      name: 'defi_record_item_status_continue',
      desc: '',
      args: [],
    );
  }

  /// `UnLockable`
  String get defi_record_item_status_unlock {
    return Intl.message(
      'UnLockable',
      name: 'defi_record_item_status_unlock',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Waiting`
  String get defi_record_item_status_unlock_waiting {
    return Intl.message(
      'Unlock Waiting',
      name: 'defi_record_item_status_unlock_waiting',
      desc: '',
      args: [],
    );
  }

  /// `Renew`
  String get defi_record_item_btn_continue {
    return Intl.message(
      'Renew',
      name: 'defi_record_item_btn_continue',
      desc: '',
      args: [],
    );
  }

  /// `Unlock`
  String get defi_record_item_btn_unlock {
    return Intl.message(
      'Unlock',
      name: 'defi_record_item_btn_unlock',
      desc: '',
      args: [],
    );
  }

  /// `Lock`
  String get defi_record_item_lock_time {
    return Intl.message(
      'Lock',
      name: 'defi_record_item_lock_time',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get defi_record_item_lock_time_day {
    return Intl.message(
      'day',
      name: 'defi_record_item_lock_time_day',
      desc: '',
      args: [],
    );
  }

  /// `Is the output (ABC)`
  String get defi_ranking_content {
    return Intl.message(
      'Is the output (ABC)',
      name: 'defi_ranking_content',
      desc: '',
      args: [],
    );
  }

  /// `Unlocked successfully`
  String get dialog_defi_unlock_sucess {
    return Intl.message(
      'Unlocked successfully',
      name: 'dialog_defi_unlock_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Locked successfully`
  String get dialog_defi_lock_sucess {
    return Intl.message(
      'Locked successfully',
      name: 'dialog_defi_lock_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Successful renewal`
  String get dialog_defi_continue_sucess {
    return Intl.message(
      'Successful renewal',
      name: 'dialog_defi_continue_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Node address or compiler address is not available`
  String get dialog_node_set_error {
    return Intl.message(
      'Node address or compiler address is not available',
      name: 'dialog_node_set_error',
      desc: '',
      args: [],
    );
  }

  /// `Save successfully`
  String get dialog_node_set_sucess {
    return Intl.message(
      'Save successfully',
      name: 'dialog_node_set_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Backup successful`
  String get dialog_save_sucess {
    return Intl.message(
      'Backup successful',
      name: 'dialog_save_sucess',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully backed up the mnemonic phrase`
  String get dialog_save_sucess_hint {
    return Intl.message(
      'You have successfully backed up the mnemonic phrase',
      name: 'dialog_save_sucess_hint',
      desc: '',
      args: [],
    );
  }

  /// `Backup failed`
  String get dialog_save_error {
    return Intl.message(
      'Backup failed',
      name: 'dialog_save_error',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the mnemonic phrase in the normal order.`
  String get dialog_save_error_hint {
    return Intl.message(
      'Please enter the mnemonic phrase in the normal order.',
      name: 'dialog_save_error_hint',
      desc: '',
      args: [],
    );
  }

  /// `Disclaimer`
  String get dialog_statement_title {
    return Intl.message(
      'Disclaimer',
      name: 'dialog_statement_title',
      desc: '',
      args: [],
    );
  }

  /// `BoxWallet code is completely open source, it complies with the open source agreement, and the ecological project initiated by the Chinese community is non-profit. So please confirm the risk yourself! BoxWallet will not collect your private key, but does not guarantee special circumstances (Such as bugs, hacker attacks), we will not make any compensation if the wallet is lost or locked. Please take your own risk. Agree means that you approve the disclaimer. If you disagree, please uninstall by yourself`
  String get dialog_statement_content {
    return Intl.message(
      'BoxWallet code is completely open source, it complies with the open source agreement, and the ecological project initiated by the Chinese community is non-profit. So please confirm the risk yourself! BoxWallet will not collect your private key, but does not guarantee special circumstances (Such as bugs, hacker attacks), we will not make any compensation if the wallet is lost or locked. Please take your own risk. Agree means that you approve the disclaimer. If you disagree, please uninstall by yourself',
      name: 'dialog_statement_content',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get dialog_statement_btn {
    return Intl.message(
      'Agree',
      name: 'dialog_statement_btn',
      desc: '',
      args: [],
    );
  }

  /// `Discover new version`
  String get dialog_update_title {
    return Intl.message(
      'Discover new version',
      name: 'dialog_update_title',
      desc: '',
      args: [],
    );
  }

  /// `A new version is available, please download the update`
  String get dialog_update_content {
    return Intl.message(
      'A new version is available, please download the update',
      name: 'dialog_update_content',
      desc: '',
      args: [],
    );
  }

  /// `A pledge requires a minimum of 100 AE`
  String get dialog_defi_token_low {
    return Intl.message(
      'A pledge requires a minimum of 100 AE',
      name: 'dialog_defi_token_low',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the information.`
  String get dialog_tx_title {
    return Intl.message(
      'Please confirm the information.',
      name: 'dialog_tx_title',
      desc: '',
      args: [],
    );
  }

  /// `Successfully received`
  String get dialog_defi_get_msg {
    return Intl.message(
      'Successfully received',
      name: 'dialog_defi_get_msg',
      desc: '',
      args: [],
    );
  }

  /// `Received successfully`
  String get dialog_defi_get {
    return Intl.message(
      'Received successfully',
      name: 'dialog_defi_get',
      desc: '',
      args: [],
    );
  }

  /// `Please backup the mnemonic phrase`
  String get dialog_save_word {
    return Intl.message(
      'Please backup the mnemonic phrase',
      name: 'dialog_save_word',
      desc: '',
      args: [],
    );
  }

  /// `For the safety of your assets, please back up your mnemonic phrase in time. If you lose your mnemonic phrase, your wallet and assets will also be lost`
  String get dialog_save_word_hint {
    return Intl.message(
      'For the safety of your assets, please back up your mnemonic phrase in time. If you lose your mnemonic phrase, your wallet and assets will also be lost',
      name: 'dialog_save_word_hint',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get dialog_dismiss {
    return Intl.message(
      'Cancel',
      name: 'dialog_dismiss',
      desc: '',
      args: [],
    );
  }

  /// `Go to backup`
  String get dialog_save_go {
    return Intl.message(
      'Go to backup',
      name: 'dialog_save_go',
      desc: '',
      args: [],
    );
  }

  /// `Broadcasting`
  String get ae_status_broadcast {
    return Intl.message(
      'Broadcasting',
      name: 'ae_status_broadcast',
      desc: '',
      args: [],
    );
  }

  /// `Domain is being claimed`
  String get ae_status_aensPreclaim {
    return Intl.message(
      'Domain is being claimed',
      name: 'ae_status_aensPreclaim',
      desc: '',
      args: [],
    );
  }

  /// `Domain is being bound`
  String get ae_status_aensBid {
    return Intl.message(
      'Domain is being bound',
      name: 'ae_status_aensBid',
      desc: '',
      args: [],
    );
  }

  /// `The domain name is being updated`
  String get ae_status_aensUpdate {
    return Intl.message(
      'The domain name is being updated',
      name: 'ae_status_aensUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Domain is being auctioned`
  String get ae_status_aensClaim {
    return Intl.message(
      'Domain is being auctioned',
      name: 'ae_status_aensClaim',
      desc: '',
      args: [],
    );
  }

  /// `Contract is being compiled`
  String get ae_status_contractEncodeCall {
    return Intl.message(
      'Contract is being compiled',
      name: 'ae_status_contractEncodeCall',
      desc: '',
      args: [],
    );
  }

  /// `Contract Calling`
  String get ae_status_contractCall {
    return Intl.message(
      'Contract Calling',
      name: 'ae_status_contractCall',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing results`
  String get ae_status_decode {
    return Intl.message(
      'Analyzing results',
      name: 'ae_status_decode',
      desc: '',
      args: [],
    );
  }

  /// `Query authorization information`
  String get ae_status_allowance {
    return Intl.message(
      'Query authorization information',
      name: 'ae_status_allowance',
      desc: '',
      args: [],
    );
  }

  /// `Change the number of authorizations`
  String get ae_status_change_allowance {
    return Intl.message(
      'Change the number of authorizations',
      name: 'ae_status_change_allowance',
      desc: '',
      args: [],
    );
  }

  /// `Set the number of authorizations`
  String get ae_status_create_allowance {
    return Intl.message(
      'Set the number of authorizations',
      name: 'ae_status_create_allowance',
      desc: '',
      args: [],
    );
  }

  /// `Node not use`
  String get tab_node_error {
    return Intl.message(
      'Node not use',
      name: 'tab_node_error',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation successful`
  String get dialog_dismiss_sucess {
    return Intl.message(
      'Cancellation successful',
      name: 'dialog_dismiss_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Successful initiation`
  String get dialog_send_sucess {
    return Intl.message(
      'Successful initiation',
      name: 'dialog_send_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Swap successfully`
  String get dialog_swap_sucess {
    return Intl.message(
      'Swap successfully',
      name: 'dialog_swap_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get swap_title {
    return Intl.message(
      'Swap',
      name: 'swap_title',
      desc: '',
      args: [],
    );
  }

  /// `My Swap`
  String get swap_title_my {
    return Intl.message(
      'My Swap',
      name: 'swap_title_my',
      desc: '',
      args: [],
    );
  }

  /// `Initiate Swap`
  String get swap_tab_1 {
    return Intl.message(
      'Initiate Swap',
      name: 'swap_tab_1',
      desc: '',
      args: [],
    );
  }

  /// `My Swap`
  String get swap_tab_2 {
    return Intl.message(
      'My Swap',
      name: 'swap_tab_2',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get swap_item_1 {
    return Intl.message(
      'Premium',
      name: 'swap_item_1',
      desc: '',
      args: [],
    );
  }

  /// `Swap count`
  String get swap_item_2 {
    return Intl.message(
      'Swap count',
      name: 'swap_item_2',
      desc: '',
      args: [],
    );
  }

  /// `Pay you`
  String get swap_item_3 {
    return Intl.message(
      'Pay you',
      name: 'swap_item_3',
      desc: '',
      args: [],
    );
  }

  /// `Swap now`
  String get swap_item_4 {
    return Intl.message(
      'Swap now',
      name: 'swap_item_4',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get swap_item_5 {
    return Intl.message(
      'Cancel',
      name: 'swap_item_5',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get swap_item_6 {
    return Intl.message(
      '',
      name: 'swap_item_6',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get tab_1 {
    return Intl.message(
      'Account',
      name: 'tab_1',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get tab_2 {
    return Intl.message(
      'Discover',
      name: 'tab_2',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get tab_3 {
    return Intl.message(
      'Setting',
      name: 'tab_3',
      desc: '',
      args: [],
    );
  }

  /// `Initiate exchange`
  String get swap_title_send {
    return Intl.message(
      'Initiate exchange',
      name: 'swap_title_send',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the quantity`
  String get swap_text_hint {
    return Intl.message(
      'Please enter the quantity',
      name: 'swap_text_hint',
      desc: '',
      args: [],
    );
  }

  /// `Amount I exchanged`
  String get swap_send_1 {
    return Intl.message(
      'Amount I exchanged',
      name: 'swap_send_1',
      desc: '',
      args: [],
    );
  }

  /// `Amount paid by the other party`
  String get swap_send_2 {
    return Intl.message(
      'Amount paid by the other party',
      name: 'swap_send_2',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get swap_send_2_2 {
    return Intl.message(
      'Premium',
      name: 'swap_send_2_2',
      desc: '',
      args: [],
    );
  }

  /// `Initiate exchange`
  String get swap_send_3 {
    return Intl.message(
      'Initiate exchange',
      name: 'swap_send_3',
      desc: '',
      args: [],
    );
  }

  /// `Exchange Instructions`
  String get swap_send_4 {
    return Intl.message(
      'Exchange Instructions',
      name: 'swap_send_4',
      desc: '',
      args: [],
    );
  }

  /// `Box Swap is a decentralized point exchange, which supports the conversion between AEX9 points and AE, the exchange process and the cancellation of transaction fees. The standards of fees are dynamically adjusted according to different currencies, and part of the fees will be airdropped to ABC users according to the proportion of positions they hold. This function is a test function and is only used for testing. Not open to the public, because all the operation in the block chain, the user experience exchange privately, such as the loss of points and other problems by the user to bear`
  String get swap_send_5 {
    return Intl.message(
      'Box Swap is a decentralized point exchange, which supports the conversion between AEX9 points and AE, the exchange process and the cancellation of transaction fees. The standards of fees are dynamically adjusted according to different currencies, and part of the fees will be airdropped to ABC users according to the proportion of positions they hold. This function is a test function and is only used for testing. Not open to the public, because all the operation in the block chain, the user experience exchange privately, such as the loss of points and other problems by the user to bear',
      name: 'swap_send_5',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get swap_buy_sell_order {
    return Intl.message(
      'Order',
      name: 'swap_buy_sell_order',
      desc: '',
      args: [],
    );
  }

  /// `My Order`
  String get swap_buy_sell_order_title {
    return Intl.message(
      'My Order',
      name: 'swap_buy_sell_order_title',
      desc: '',
      args: [],
    );
  }

  /// `Sold`
  String get swap_buy_sell_order_tab1 {
    return Intl.message(
      'Sold',
      name: 'swap_buy_sell_order_tab1',
      desc: '',
      args: [],
    );
  }

  /// `Bought`
  String get swap_buy_sell_order_tab2 {
    return Intl.message(
      'Bought',
      name: 'swap_buy_sell_order_tab2',
      desc: '',
      args: [],
    );
  }

  /// `Seller`
  String get swap_buy_sell_order_item_1 {
    return Intl.message(
      'Seller',
      name: 'swap_buy_sell_order_item_1',
      desc: '',
      args: [],
    );
  }

  /// `Buyer`
  String get swap_buy_sell_order_item_2 {
    return Intl.message(
      'Buyer',
      name: 'swap_buy_sell_order_item_2',
      desc: '',
      args: [],
    );
  }

  /// `Created time`
  String get swap_buy_sell_order_item_3 {
    return Intl.message(
      'Created time',
      name: 'swap_buy_sell_order_item_3',
      desc: '',
      args: [],
    );
  }

  /// `Payment time`
  String get swap_buy_sell_order_item_4 {
    return Intl.message(
      'Payment time',
      name: 'swap_buy_sell_order_item_4',
      desc: '',
      args: [],
    );
  }

  /// `Created Height`
  String get swap_buy_sell_order_item_5 {
    return Intl.message(
      'Created Height',
      name: 'swap_buy_sell_order_item_5',
      desc: '',
      args: [],
    );
  }

  /// `Payment Height`
  String get swap_buy_sell_order_item_6 {
    return Intl.message(
      'Payment Height',
      name: 'swap_buy_sell_order_item_6',
      desc: '',
      args: [],
    );
  }

  /// `Sold Quantity`
  String get swap_buy_sell_order_item_7 {
    return Intl.message(
      'Sold Quantity',
      name: 'swap_buy_sell_order_item_7',
      desc: '',
      args: [],
    );
  }

  /// `Payment Quantity (AE)`
  String get swap_buy_sell_order_item_8 {
    return Intl.message(
      'Payment Quantity (AE)',
      name: 'swap_buy_sell_order_item_8',
      desc: '',
      args: [],
    );
  }

  /// `Confirm height`
  String get swap_buy_sell_order_item_9 {
    return Intl.message(
      'Confirm height',
      name: 'swap_buy_sell_order_item_9',
      desc: '',
      args: [],
    );
  }

  /// `Team Forum`
  String get aepp_item_1 {
    return Intl.message(
      'Team Forum',
      name: 'aepp_item_1',
      desc: '',
      args: [],
    );
  }

  /// `Feedback problems`
  String get aepp_item_1_1 {
    return Intl.message(
      'Feedback problems',
      name: 'aepp_item_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Connect the blockchain with your fingertips`
  String get aepp_item_2_1 {
    return Intl.message(
      'Connect the blockchain with your fingertips',
      name: 'aepp_item_2_1',
      desc: '',
      args: [],
    );
  }

  /// `AE official development wallet`
  String get aepp_item_3_1 {
    return Intl.message(
      'AE official development wallet',
      name: 'aepp_item_3_1',
      desc: '',
      args: [],
    );
  }

  /// `Remember what you remember, think what you think`
  String get aepp_item_4_1 {
    return Intl.message(
      'Remember what you remember, think what you think',
      name: 'aepp_item_4_1',
      desc: '',
      args: [],
    );
  }

  /// `Peer-to-peer social tipping platform`
  String get aepp_item_5_1 {
    return Intl.message(
      'Peer-to-peer social tipping platform',
      name: 'aepp_item_5_1',
      desc: '',
      args: [],
    );
  }

  /// `No transaction record temporarily`
  String get home_no_record {
    return Intl.message(
      'No transaction record temporarily',
      name: 'home_no_record',
      desc: '',
      args: [],
    );
  }

  /// `Integral`
  String get home_token {
    return Intl.message(
      'Integral',
      name: 'home_token',
      desc: '',
      args: [],
    );
  }

  /// `Send and receive your Integral`
  String get home_send_receive {
    return Intl.message(
      'Send and receive your Integral',
      name: 'home_send_receive',
      desc: '',
      args: [],
    );
  }

  /// `Partner`
  String get aepps_friend {
    return Intl.message(
      'Partner',
      name: 'aepps_friend',
      desc: '',
      args: [],
    );
  }

  /// `Description of Listing`
  String get tokens_dialog_title {
    return Intl.message(
      'Description of Listing',
      name: 'tokens_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `AEX9 protocol tokens can be created for free through aeasy.io. To increase the user experience and prevent the tokens from flying randomly, the excellent tokens set up in the Integral list need to be reviewed. \n Listing process: on The Integral fee is 10000AE and 1000ABC. This fee is used as the Integral lock-up fee. Any centralized exchange or delisting on the Integral can return the pledge Integral \n Delisting process: Delisting tokens requires recycling all tokens on the market The Integral price will be recovered according to the collected value. Or the Integral will not flow for a long time. Form a dead Integral \n Please prepare the contract address, Integral name, Integral logo to AE BBS @baixin`
  String get tokens_dialog_content {
    return Intl.message(
      'AEX9 protocol tokens can be created for free through aeasy.io. To increase the user experience and prevent the tokens from flying randomly, the excellent tokens set up in the Integral list need to be reviewed. \n Listing process: on The Integral fee is 10000AE and 1000ABC. This fee is used as the Integral lock-up fee. Any centralized exchange or delisting on the Integral can return the pledge Integral \n Delisting process: Delisting tokens requires recycling all tokens on the market The Integral price will be recovered according to the collected value. Or the Integral will not flow for a long time. Form a dead Integral \n Please prepare the contract address, Integral name, Integral logo to AE BBS @baixin',
      name: 'tokens_dialog_content',
      desc: '',
      args: [],
    );
  }

  /// `Pointers`
  String get name_point {
    return Intl.message(
      'Pointers',
      name: 'name_point',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get name_point_conform {
    return Intl.message(
      'Confirm',
      name: 'name_point_conform',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the address to which the domain name refers`
  String get name_point_title {
    return Intl.message(
      'Please enter the address to which the domain name refers',
      name: 'name_point_title',
      desc: '',
      args: [],
    );
  }

  /// `name already register`
  String get msg_name_already {
    return Intl.message(
      'name already register',
      name: 'msg_name_already',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient wallet balance`
  String get msg_name_balance_error {
    return Intl.message(
      'Insufficient wallet balance',
      name: 'msg_name_balance_error',
      desc: '',
      args: [],
    );
  }

  /// `Copy Th Hash`
  String get dialog_copy {
    return Intl.message(
      'Copy Th Hash',
      name: 'dialog_copy',
      desc: '',
      args: [],
    );
  }

  /// `Transfer the domain name to your new address`
  String get name_transfer_title {
    return Intl.message(
      'Transfer the domain name to your new address',
      name: 'name_transfer_title',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get name_transfer_conform {
    return Intl.message(
      'Transfer',
      name: 'name_transfer_conform',
      desc: '',
      args: [],
    );
  }

  /// `Transferring domain name`
  String get ae_status_aensTransfer {
    return Intl.message(
      'Transferring domain name',
      name: 'ae_status_aensTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Unlock successfully`
  String get dialog_unlock_sucess {
    return Intl.message(
      'Unlock successfully',
      name: 'dialog_unlock_sucess',
      desc: '',
      args: [],
    );
  }

  /// `Unlocked successfully`
  String get dialog_unlock_sucess_msg {
    return Intl.message(
      'Unlocked successfully',
      name: 'dialog_unlock_sucess_msg',
      desc: '',
      args: [],
    );
  }

  /// `There are benefits that have not been received. Do you want to continue to cancel?`
  String get dialog_ae_no_get {
    return Intl.message(
      'There are benefits that have not been received. Do you want to continue to cancel?',
      name: 'dialog_ae_no_get',
      desc: '',
      args: [],
    );
  }

  /// `The number of mappings is greater than the number of wallets, and the automatic blacklist function has been triggered`
  String get dialog_defi_blacklist {
    return Intl.message(
      'The number of mappings is greater than the number of wallets, and the automatic blacklist function has been triggered',
      name: 'dialog_defi_blacklist',
      desc: '',
      args: [],
    );
  }

  /// `Need to wait`
  String get dialog_defi_wait1 {
    return Intl.message(
      'Need to wait',
      name: 'dialog_defi_wait1',
      desc: '',
      args: [],
    );
  }

  /// `minutes receive the income in `
  String get dialog_defi_wait2 {
    return Intl.message(
      'minutes receive the income in ',
      name: 'dialog_defi_wait2',
      desc: '',
      args: [],
    );
  }

  /// `Risk Warning Statement`
  String get dialog_privacy_hint {
    return Intl.message(
      'Risk Warning Statement',
      name: 'dialog_privacy_hint',
      desc: '',
      args: [],
    );
  }

  /// `Forced to use`
  String get dialog_privacy_confirm {
    return Intl.message(
      'Forced to use',
      name: 'dialog_privacy_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Box Defi Pledge is one way to get ABC points. An ABC integral has no value and is useless. It is only a sample program written by the developer to experience the blockchain. Not to market development, if you download through other means and try to use the pledge, please turn off this feature.`
  String get dialog_defi_hint {
    return Intl.message(
      'Box Defi Pledge is one way to get ABC points. An ABC integral has no value and is useless. It is only a sample program written by the developer to experience the blockchain. Not to market development, if you download through other means and try to use the pledge, please turn off this feature.',
      name: 'dialog_defi_hint',
      desc: '',
      args: [],
    );
  }

  /// `The exchange function of Box Swap is the exchange between points and AE. The whole function is an exchange example written for the developer's personal preference, which is not used officially or open to the public. The points exchanged (ABC, WTT, AEG, etc.) have no value. Just as a collection. Since the function is realized based on blockchain, if the user uses it without authorization, please quit in time. If the forced use results in the loss of points and the floating exchange ratio between points and AE, it has nothing to do with the developer and the project party, and the user should bear the responsibility by himself.`
  String get dialog_swap_hint {
    return Intl.message(
      'The exchange function of Box Swap is the exchange between points and AE. The whole function is an exchange example written for the developer\'s personal preference, which is not used officially or open to the public. The points exchanged (ABC, WTT, AEG, etc.) have no value. Just as a collection. Since the function is realized based on blockchain, if the user uses it without authorization, please quit in time. If the forced use results in the loss of points and the floating exchange ratio between points and AE, it has nothing to do with the developer and the project party, and the user should bear the responsibility by himself.',
      name: 'dialog_swap_hint',
      desc: '',
      args: [],
    );
  }

  /// `The domain name system is the underlying function of the user blockchain. This application is only for demonstration, and all operations directly access the blockchain. Users should use it at their own risk. No liability shall be assumed for forced use of this app.`
  String get dialog_name_hint {
    return Intl.message(
      'The domain name system is the underlying function of the user blockchain. This application is only for demonstration, and all operations directly access the blockchain. Users should use it at their own risk. No liability shall be assumed for forced use of this app.',
      name: 'dialog_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Temporary mapping risk tip`
  String get dialog_defi_temp_hint {
    return Intl.message(
      'Temporary mapping risk tip',
      name: 'dialog_defi_temp_hint',
      desc: '',
      args: [],
    );
  }

  /// `According to the strong demand of the community, this mapping is a temporary pre-hyperchain mapping, not the final version, and the output multiplier will be different from the normal version. Is a temporary mapped version to reward old users.`
  String get dialog_defi_temp_hint2 {
    return Intl.message(
      'According to the strong demand of the community, this mapping is a temporary pre-hyperchain mapping, not the final version, and the output multiplier will be different from the normal version. Is a temporary mapped version to reward old users.',
      name: 'dialog_defi_temp_hint2',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get settings_contact {
    return Intl.message(
      'Contact us',
      name: 'settings_contact',
      desc: '',
      args: [],
    );
  }

  /// `User-friendly multi-chain wallet`
  String get login_sg1 {
    return Intl.message(
      'User-friendly multi-chain wallet',
      name: 'login_sg1',
      desc: '',
      args: [],
    );
  }

  /// `Strong project incubator`
  String get login_sg2 {
    return Intl.message(
      'Strong project incubator',
      name: 'login_sg2',
      desc: '',
      args: [],
    );
  }

  /// `Customized ecological support`
  String get login_sg3 {
    return Intl.message(
      'Customized ecological support',
      name: 'login_sg3',
      desc: '',
      args: [],
    );
  }

  /// `Create a new wallet`
  String get login_btn_create {
    return Intl.message(
      'Create a new wallet',
      name: 'login_btn_create',
      desc: '',
      args: [],
    );
  }

  /// `Import existing wallet`
  String get login_btn_input {
    return Intl.message(
      'Import existing wallet',
      name: 'login_btn_input',
      desc: '',
      args: [],
    );
  }

  /// `Select chain`
  String get select_chain_page_select_chain {
    return Intl.message(
      'Select chain',
      name: 'select_chain_page_select_chain',
      desc: '',
      args: [],
    );
  }

  /// `Create a new Wallet`
  String get select_chain_page_create_wallet {
    return Intl.message(
      'Create a new Wallet',
      name: 'select_chain_page_create_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Add a new chain`
  String get select_chain_page_add_chain {
    return Intl.message(
      'Add a new chain',
      name: 'select_chain_page_add_chain',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get select_wallet_page_wallet {
    return Intl.message(
      'Wallet',
      name: 'select_wallet_page_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Add new account`
  String get select_wallet_page_add_account {
    return Intl.message(
      'Add new account',
      name: 'select_wallet_page_add_account',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get select_wallet_page_account {
    return Intl.message(
      'Account',
      name: 'select_wallet_page_account',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get select_wallet_page_input_account {
    return Intl.message(
      'Import',
      name: 'select_wallet_page_input_account',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get select_wallet_page_create_account {
    return Intl.message(
      'Create',
      name: 'select_wallet_page_create_account',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get select_wallet_page_add_account_1 {
    return Intl.message(
      'Add',
      name: 'select_wallet_page_add_account_1',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get select_wallet_page_add_account_2 {
    return Intl.message(
      'Account',
      name: 'select_wallet_page_add_account_2',
      desc: '',
      args: [],
    );
  }

  /// `The wallet already exists, please create an account directly`
  String get dialog_add_wallet_error {
    return Intl.message(
      'The wallet already exists, please create an account directly',
      name: 'dialog_add_wallet_error',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get dialog_delete_account {
    return Intl.message(
      'Delete Account',
      name: 'dialog_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Deleting an account will clear all data of the account locally. It is irreversible. Are you sure?`
  String get dialog_delete_account_msg {
    return Intl.message(
      'Deleting an account will clear all data of the account locally. It is irreversible. Are you sure?',
      name: 'dialog_delete_account_msg',
      desc: '',
      args: [],
    );
  }

  /// `Select Points`
  String get ae_select_token_page_title {
    return Intl.message(
      'Select Points',
      name: 'ae_select_token_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get ae_tx_detail_page_title {
    return Intl.message(
      'Details',
      name: 'ae_tx_detail_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get ae_tx_detail_page_height {
    return Intl.message(
      'Height',
      name: 'ae_tx_detail_page_height',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get ae_tx_detail_page_height_confirm {
    return Intl.message(
      'Confirm',
      name: 'ae_tx_detail_page_height_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Certificate (hash)`
  String get ae_tx_detail_page_hash {
    return Intl.message(
      'Certificate (hash)',
      name: 'ae_tx_detail_page_hash',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get ae_tx_detail_page_type {
    return Intl.message(
      'Type',
      name: 'ae_tx_detail_page_type',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get ae_tx_detail_page_count {
    return Intl.message(
      'Amount',
      name: 'ae_tx_detail_page_count',
      desc: '',
      args: [],
    );
  }

  /// `Sender`
  String get ae_tx_detail_page_from {
    return Intl.message(
      'Sender',
      name: 'ae_tx_detail_page_from',
      desc: '',
      args: [],
    );
  }

  /// `Recipient`
  String get ae_tx_detail_page_to {
    return Intl.message(
      'Recipient',
      name: 'ae_tx_detail_page_to',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get ae_tx_detail_page_fee {
    return Intl.message(
      'Fee',
      name: 'ae_tx_detail_page_fee',
      desc: '',
      args: [],
    );
  }

  /// `Payload`
  String get ae_tx_detail_page_payload {
    return Intl.message(
      'Payload',
      name: 'ae_tx_detail_page_payload',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get cfx_home_page_transfer_send {
    return Intl.message(
      'Send',
      name: 'cfx_home_page_transfer_send',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get cfx_home_page_transfer_receive {
    return Intl.message(
      'Receive',
      name: 'cfx_home_page_transfer_receive',
      desc: '',
      args: [],
    );
  }

  /// `Random`
  String get cfx_home_page_transfer_random {
    return Intl.message(
      'Random',
      name: 'cfx_home_page_transfer_random',
      desc: '',
      args: [],
    );
  }

  /// `Select Points`
  String get cfx_select_token_page_title {
    return Intl.message(
      'Select Points',
      name: 'cfx_select_token_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get cfx_tx_detail_page_title {
    return Intl.message(
      'Detail',
      name: 'cfx_tx_detail_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get cfx_tx_detail_page_height {
    return Intl.message(
      'Height',
      name: 'cfx_tx_detail_page_height',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get cfx_tx_detail_page_height_confirm {
    return Intl.message(
      'Confirm',
      name: 'cfx_tx_detail_page_height_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Certificate (hash)`
  String get cfx_tx_detail_page_hash {
    return Intl.message(
      'Certificate (hash)',
      name: 'cfx_tx_detail_page_hash',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get cfx_tx_detail_page_type {
    return Intl.message(
      'Type',
      name: 'cfx_tx_detail_page_type',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get cfx_tx_detail_page_count {
    return Intl.message(
      'Amount',
      name: 'cfx_tx_detail_page_count',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get cfx_tx_detail_page_from {
    return Intl.message(
      'Send',
      name: 'cfx_tx_detail_page_from',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get cfx_tx_detail_page_to {
    return Intl.message(
      'Receive',
      name: 'cfx_tx_detail_page_to',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get cfx_tx_detail_page_fee {
    return Intl.message(
      'Fee',
      name: 'cfx_tx_detail_page_fee',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get cfx_tx_detail_page_time {
    return Intl.message(
      'Time',
      name: 'cfx_tx_detail_page_time',
      desc: '',
      args: [],
    );
  }

  /// `Era`
  String get cfx_tx_detail_page_jiyuan {
    return Intl.message(
      'Era',
      name: 'cfx_tx_detail_page_jiyuan',
      desc: '',
      args: [],
    );
  }

  /// `Please notice that you are accessing a third party DApp. Your use of the third party DApp will be subject to the User Agreement and Privacy Policy of the third party DApp, and the third DApp`
  String get cfx_dapp_mag1 {
    return Intl.message(
      'Please notice that you are accessing a third party DApp. Your use of the third party DApp will be subject to the User Agreement and Privacy Policy of the third party DApp, and the third DApp',
      name: 'cfx_dapp_mag1',
      desc: '',
      args: [],
    );
  }

  /// `itself will be directly and solely responsible to you.`
  String get cfx_dapp_mag2 {
    return Intl.message(
      'itself will be directly and solely responsible to you.',
      name: 'cfx_dapp_mag2',
      desc: '',
      args: [],
    );
  }

  /// `Clear all data`
  String get setting_clear_data_title {
    return Intl.message(
      'Clear all data',
      name: 'setting_clear_data_title',
      desc: '',
      args: [],
    );
  }

  /// `This action will irreversibly empty all data of \nthe wallet (including all accounts), please operate with caution. Confirm to continue?`
  String get setting_clear_data_content {
    return Intl.message(
      'This action will irreversibly empty all data of \nthe wallet (including all accounts), please operate with caution. Confirm to continue?',
      name: 'setting_clear_data_content',
      desc: '',
      args: [],
    );
  }

  /// `Proof of trading`
  String get dialog_hint_hash {
    return Intl.message(
      'Proof of trading',
      name: 'dialog_hint_hash',
      desc: '',
      args: [],
    );
  }

  /// `Backup mnemonic phrase`
  String get CreateMnemonicCopyPage_title {
    return Intl.message(
      'Backup mnemonic phrase',
      name: 'CreateMnemonicCopyPage_title',
      desc: '',
      args: [],
    );
  }

  /// `Attention\n· Do not disclose the mnemonic words to anyone\n· Once the mnemonic words are lost, the assets cannot be restored\n· Please do not use any screenshots or network transmission to make backups\n· In any case, please do not uninstall the wallet app easily`
  String get CreateMnemonicCopyPage_tips {
    return Intl.message(
      'Attention\n· Do not disclose the mnemonic words to anyone\n· Once the mnemonic words are lost, the assets cannot be restored\n· Please do not use any screenshots or network transmission to make backups\n· In any case, please do not uninstall the wallet app easily',
      name: 'CreateMnemonicCopyPage_tips',
      desc: '',
      args: [],
    );
  }

  /// `Set a security password`
  String get SetPasswordPage_set_password {
    return Intl.message(
      'Set a security password',
      name: 'SetPasswordPage_set_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm security Password`
  String get SetPasswordPage_set_password_re {
    return Intl.message(
      'Confirm security Password',
      name: 'SetPasswordPage_set_password_re',
      desc: '',
      args: [],
    );
  }

  /// `The two passwords are inconsistent`
  String get SetPasswordPage_set_error_pas_2 {
    return Intl.message(
      'The two passwords are inconsistent',
      name: 'SetPasswordPage_set_error_pas_2',
      desc: '',
      args: [],
    );
  }

  /// `Enter a password of at least 8 digits`
  String get SetPasswordPage_set_error_pas_size {
    return Intl.message(
      'Enter a password of at least 8 digits',
      name: 'SetPasswordPage_set_error_pas_size',
      desc: '',
      args: [],
    );
  }

  /// `Tip: The security password is used for protecting your private key. Please avoid choosing a simple password. BoxWallet will not store your password, nor can it help you retrieve your password. Please keep your password safe.`
  String get SetPasswordPage_set_tips {
    return Intl.message(
      'Tip: The security password is used for protecting your private key. Please avoid choosing a simple password. BoxWallet will not store your password, nor can it help you retrieve your password. Please keep your password safe.',
      name: 'SetPasswordPage_set_tips',
      desc: '',
      args: [],
    );
  }

  /// `Select the public chain you want to create, you can create multiple chains at the same time`
  String get SelectChainCreatePage_select_chain {
    return Intl.message(
      'Select the public chain you want to create, you can create multiple chains at the same time',
      name: 'SelectChainCreatePage_select_chain',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one public chain`
  String get SelectChainCreatePage_error {
    return Intl.message(
      'Please select at least one public chain',
      name: 'SelectChainCreatePage_error',
      desc: '',
      args: [],
    );
  }

  /// `Add New Account`
  String get AddAccountPage_title {
    return Intl.message(
      'Add New Account',
      name: 'AddAccountPage_title',
      desc: '',
      args: [],
    );
  }

  /// `You can add or create your new account under the public chain in the following ways`
  String get AddAccountPage_title_2 {
    return Intl.message(
      'You can add or create your new account under the public chain in the following ways',
      name: 'AddAccountPage_title_2',
      desc: '',
      args: [],
    );
  }

  /// `Or quickly import mnemonic words from other accounts (the same mnemonic phrase can create multiple public chain accounts)`
  String get AddAccountPage_title_3 {
    return Intl.message(
      'Or quickly import mnemonic words from other accounts (the same mnemonic phrase can create multiple public chain accounts)',
      name: 'AddAccountPage_title_3',
      desc: '',
      args: [],
    );
  }

  /// `Create mnemonic`
  String get AddAccountPage_create {
    return Intl.message(
      'Create mnemonic',
      name: 'AddAccountPage_create',
      desc: '',
      args: [],
    );
  }

  /// `Import mnemonic`
  String get AddAccountPage_import {
    return Intl.message(
      'Import mnemonic',
      name: 'AddAccountPage_import',
      desc: '',
      args: [],
    );
  }

  /// ` Select mnemonics`
  String get AddAccountPage_copy {
    return Intl.message(
      ' Select mnemonics',
      name: 'AddAccountPage_copy',
      desc: '',
      args: [],
    );
  }

  /// `Select Mnemonic Word`
  String get SelectMnemonicPage_title {
    return Intl.message(
      'Select Mnemonic Word',
      name: 'SelectMnemonicPage_title',
      desc: '',
      args: [],
    );
  }

  /// `Please select one of the existing mnemonic words in other public chains for quick login`
  String get SelectMnemonicPage_title2 {
    return Intl.message(
      'Please select one of the existing mnemonic words in other public chains for quick login',
      name: 'SelectMnemonicPage_title2',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic`
  String get SettingPage_mnemonic {
    return Intl.message(
      'Mnemonic',
      name: 'SettingPage_mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic Word`
  String get LookMnemonicPage_title {
    return Intl.message(
      'Mnemonic Word',
      name: 'LookMnemonicPage_title',
      desc: '',
      args: [],
    );
  }

  /// `The following mnemonic phrase of the current account can be used to restore the wallet, please do not disclose it to others`
  String get LookMnemonicPage_title2 {
    return Intl.message(
      'The following mnemonic phrase of the current account can be used to restore the wallet, please do not disclose it to others',
      name: 'LookMnemonicPage_title2',
      desc: '',
      args: [],
    );
  }

  /// `Generate a quick wallet quick recovery code, which can be used to quickly log in to the wallet without the trouble of typing mnemonic words`
  String get LookMnemonicPage_title3 {
    return Intl.message(
      'Generate a quick wallet quick recovery code, which can be used to quickly log in to the wallet without the trouble of typing mnemonic words',
      name: 'LookMnemonicPage_title3',
      desc: '',
      args: [],
    );
  }

  /// `Set protection code`
  String get LookMnemonicPage_msg {
    return Intl.message(
      'Set protection code',
      name: 'LookMnemonicPage_msg',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get LookMnemonicPage_btn {
    return Intl.message(
      'Generate',
      name: 'LookMnemonicPage_btn',
      desc: '',
      args: [],
    );
  }

  /// `Please keep your security code properly, it can be used when restoring your wallet`
  String get BoxCodeMnemonicPage_title {
    return Intl.message(
      'Please keep your security code properly, it can be used when restoring your wallet',
      name: 'BoxCodeMnemonicPage_title',
      desc: '',
      args: [],
    );
  }

  /// `Copy security code`
  String get BoxCodeMnemonicPage_btn {
    return Intl.message(
      'Copy security code',
      name: 'BoxCodeMnemonicPage_btn',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get CfxTransferConfirmPage_title {
    return Intl.message(
      'Details',
      name: 'CfxTransferConfirmPage_title',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get CfxTransferConfirmPage_from {
    return Intl.message(
      'From',
      name: 'CfxTransferConfirmPage_from',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get CfxTransferConfirmPage_to {
    return Intl.message(
      'to',
      name: 'CfxTransferConfirmPage_to',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get CfxTransferConfirmPage_count {
    return Intl.message(
      'Amount',
      name: 'CfxTransferConfirmPage_count',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get CfxTransferConfirmPage_fee {
    return Intl.message(
      'Fee',
      name: 'CfxTransferConfirmPage_fee',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get CfxTransferConfirmPage_data {
    return Intl.message(
      'Data',
      name: 'CfxTransferConfirmPage_data',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a mnemonic consisting of 12 words separated by Spaces`
  String get account_login_msg {
    return Intl.message(
      'Please enter a mnemonic consisting of 12 words separated by Spaces',
      name: 'account_login_msg',
      desc: '',
      args: [],
    );
  }

  /// `Set nickname`
  String get SetAddressNamePage_title {
    return Intl.message(
      'Set nickname',
      name: 'SetAddressNamePage_title',
      desc: '',
      args: [],
    );
  }

  /// `Set an alias for the address`
  String get SetAddressNamePage_title2 {
    return Intl.message(
      'Set an alias for the address',
      name: 'SetAddressNamePage_title2',
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