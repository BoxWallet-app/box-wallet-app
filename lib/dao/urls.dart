//OSS HOST
import 'dart:core';


const OOS_HOST = 'https://ae-source.oss-cn-hongkong.aliyuncs.com/';
const WE_TRUE_URL = 'https://api.wetrue.io';
const ETH_TOKEN_PRICE = 'https://preserver.mytokenpocket.vip/v1/wallet/token_price_list';
const ETH_TOKEN_PRICE_RATE = 'https://preserver.mytokenpocket.vip/v1/currency_rate_list_new';

class Host {

  static String? BASE_HOST = 'https://boxwallet.app';

  //获取区块高度
  static var BLOCK_TOP = Host.BASE_HOST! + '/api/ae/block_top';

//获取拍卖中的域名
  static var NAME_AUCTIONS = BASE_HOST! + '/api/names/auctions';

//获取拍卖中的域名-价格
  static var NAME_PRICE = BASE_HOST! + '/api/names/price';

//获取拍即将过期的域名
  static var NAME_OVER = BASE_HOST! + '/api/names/over';

//获取我的注册中域名
  static var NAME_MY_REGISTER = BASE_HOST! + '/api/names/my/register';

//获取我的已注册域名
  static var NAME_MY_OVER = BASE_HOST! + '/api/names/my/over';

//注册域名
  static var NAME_ADD = BASE_HOST! + '/api/names/claim';

//更新域名
  static var NAME_UPDATE = BASE_HOST! + '/api/names/update';

//声明域名
  static var NAME_PRECLAI = BASE_HOST! + '/api/names/preclaim';

//域名详情
  static var NAME_INFO = BASE_HOST! + '/api/names/info';

//交易记录
  static var SWAP_LIST = BASE_HOST! + '/api/contract/swap/records';

//我的兑换记录
  static var SWAP_MY_LIST = BASE_HOST! + '/api/contract/swap/records/my';

//我的售卖
  static var SWAP_MY_BUY_LIST = BASE_HOST! + '/api/contract/swap/records/my/buy';

//我的购买
  static var SWAP_MY_SELL_LIST = BASE_HOST! + '/api/contract/swap/records/my/sell';

//用户详情
  static var ACCOUNT_INFO = BASE_HOST! + '/api/user/info';

//生成账户
  static var USER_REGISTER = BASE_HOST! + '/api/user/register';

//登录账户
  static var USER_LOGIN = BASE_HOST! + '/api/user/login';

//基础数据
  static var BASE_DATA = BASE_HOST! + '/api/base/data';

//基础Name数据
  static var BASE_NAME_DATA = BASE_HOST! + '/api/names/base';

//交易记录
  static var WALLET_RECORD = BASE_HOST! + '/api/wallet/transfer/record';

//交易
  static var WALLET_TRANSFER = BASE_HOST! + '/api/wallet/transfer';

//获取合约余额
  static var CONTRACT_BALANCE = BASE_HOST! + '/api/aex9/balance';

//获取合约基本信息
  static var CONTRACT_INFO = BASE_HOST! + '/api/defi/info';

//获取交易记录
  static var CONTRACT_RECORD = BASE_HOST! + '/api/contract/record';

//调用合约
  static var CONTRACT_CALL = BASE_HOST! + '/api/contract/call';

//获取hash
  static var TH_HASH = BASE_HOST! + '/api/ae/th_hash';

//调用合约转账
  static var CONTRACT_TRANSFER = BASE_HOST! + '/api/contract/transfer';

//查看合约结果
  static var CONTRACT_DECODE = BASE_HOST! + '/api/contract/decode';

//排行榜
  static var CONTRACT_RANKING = BASE_HOST! + '/api/aex9/ranking';

//广播
  static var TX_BROADCAST = BASE_HOST! + '/api/tx/broadcast';

//Tokens列表
  static var TOKEN_LIST = BASE_HOST! + '/api/tokens/list';

//banner
  static var BANNER = BASE_HOST! + '/api/banner';

//版本号
  static var VERSION = BASE_HOST! + '/api/version';

//价格
// const PRICE = 'https://api.coingecko.com/api/v3/simple/price';
  static var PRICE = 'https://aebox.io/api/price';

//绑定的域名
  static var NAME = 'https://mainnet.aeternity.io/middleware/names/reverse/';

//域名归属
  static var NAME_OWNER = '/v2/names/';
//兑换币种列表
  static var SWAP_COIN_LIST = BASE_HOST! + '/api/swap/coin/list';
////兑换币种下用户挂单
  static var SWAP_COIN_ACCOUNT = BASE_HOST! + '/api/swap/coin/account';
////兑换币种下正在挂单的
  static var SWAP_COIN_ACCOUNT_MY = BASE_HOST! + '/api/swap/coin/account/my';
//兑换订单
  static var SWAP_COIN_ORDER_MY = BASE_HOST! + '/api/swap/coin/order/my';

  static var AEX9_ALLOWANCE = BASE_HOST! + '/api/aex9/allowance';

  static var APP_STORE = BASE_HOST! + '/api/config/store';

  static var AEX9_RECORD = BASE_HOST! + '/api/tokens/record';

//Cfx
  static var CFX_BALANCE = BASE_HOST! + '/cfx/api/balance';
  static var CFX_TRANSACTION = BASE_HOST! + '/cfx/api/transaction';
  static var CFX_TOKENS = BASE_HOST! + '/cfx/api/tokens/list';
  static var CFX_TOKENS_ADDRESS = BASE_HOST! + '/cfx/api/tokens/by-address';
  static var CFX_TRANSACTION_HASH = BASE_HOST! + '/cfx/api/transaction/hash';
  static var CFX_CRC20_TRANSACTION_HASH = BASE_HOST! + '/cfx/api/crc20/transaction';
  static var CFX_NFT_BALANCE = BASE_HOST! + '/cfx/api/nft/balance';
  static var CFX_NFT_TOKEN = BASE_HOST! + '/cfx/api/nft/token';
  static var CFX_NFT_PREVIEW = BASE_HOST! + '/cfx/api/nft/preview';

//ETH
  static var ETH_TOKEN_LIST_ACTIVITY = BASE_HOST! + '/eth/api/token_list/activity';
  static var ETH_TRANSFER_RECORD = BASE_HOST! + '/eth/api/transaction_action/universal_list';
  static var ETH_TOKEN_HOT_LIST = BASE_HOST! + '/eth/api/token/hot_list';
  static var ETH_TOKEN_SEARCH = BASE_HOST! + '/eth/api/token/search';
  static var ETH_FEE = BASE_HOST! + '/eth/api/block_chain/fee_list';
}

