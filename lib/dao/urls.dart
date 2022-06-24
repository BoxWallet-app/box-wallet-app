//OSS HOST
import 'dart:core';

const OOS_HOST = 'https://ae-source.oss-cn-hongkong.aliyuncs.com/';
const WE_TRUE_URL = 'https://api.wetrue.io';
const ETH_TOKEN_PRICE = 'https://preserver.mytokenpocket.vip/v1/wallet/token_price_list';
const ETH_TOKEN_PRICE_RATE = 'https://preserver.mytokenpocket.vip/v1/currency_rate_list_new';

class Host {
  static String? baseHost = 'https://boxwallet.app';
  static String? ossHost = 'https://oss-box-files.oss-cn-hangzhou.aliyuncs.com';

  //获取区块高度
  static var urlBlockTop = Host.baseHost! + '/api/ae/block_top';

//获取拍卖中的域名
  static var urlNameAuctions = baseHost! + '/api/names/auctions';

//获取拍卖中的域名-价格
  static var urlNamePrice = baseHost! + '/api/names/price';

//获取拍即将过期的域名
  static var NAME_OVER = baseHost! + '/api/names/over';

//获取我的注册中域名
  static var NAME_MY_REGISTER = baseHost! + '/api/names/my/register';

//获取我的已注册域名
  static var NAME_MY_OVER = baseHost! + '/api/names/my/over';

//注册域名
  static var NAME_ADD = baseHost! + '/api/names/claim';

//更新域名
  static var NAME_UPDATE = baseHost! + '/api/names/update';

//声明域名
  static var NAME_PRECLAI = baseHost! + '/api/names/preclaim';

//域名详情
  static var NAME_INFO = baseHost! + '/api/names/info';

//交易记录
  static var SWAP_LIST = baseHost! + '/api/contract/swap/records';

//我的兑换记录
  static var SWAP_MY_LIST = baseHost! + '/api/contract/swap/records/my';

//我的售卖
  static var SWAP_MY_BUY_LIST = baseHost! + '/api/contract/swap/records/my/buy';

//我的购买
  static var SWAP_MY_SELL_LIST = baseHost! + '/api/contract/swap/records/my/sell';

//用户详情
  static var ACCOUNT_INFO = baseHost! + '/api/user/info';

//生成账户
  static var USER_REGISTER = baseHost! + '/api/user/register';

//登录账户
  static var USER_LOGIN = baseHost! + '/api/user/login';

//基础数据
  static var BASE_DATA = baseHost! + '/api/base/data';

//基础Name数据
  static var BASE_NAME_DATA = baseHost! + '/api/names/base';

//交易记录
  static var WALLET_RECORD = baseHost! + '/api/wallet/transfer/record';

//交易
  static var WALLET_TRANSFER = baseHost! + '/api/wallet/transfer';

//获取合约余额
  static var CONTRACT_BALANCE = baseHost! + '/api/aex9/balance';

//获取合约基本信息
  static var CONTRACT_INFO = baseHost! + '/api/defi/info';

//获取交易记录
  static var CONTRACT_RECORD = baseHost! + '/api/contract/record';

//调用合约
  static var CONTRACT_CALL = baseHost! + '/api/contract/call';

//获取hash
  static var TH_HASH = baseHost! + '/api/ae/th_hash';

//调用合约转账
  static var CONTRACT_TRANSFER = baseHost! + '/api/contract/transfer';

//查看合约结果
  static var CONTRACT_DECODE = baseHost! + '/api/contract/decode';

//排行榜
  static var CONTRACT_RANKING = baseHost! + '/api/aex9/ranking';

//广播
  static var TX_BROADCAST = baseHost! + '/api/tx/broadcast';

//Tokens列表
  static var urlTokenList = baseHost! + '/api/tokens/list';

//banner
  static var BANNER = baseHost! + '/api/banner';

//版本号
  static var VERSION = baseHost! + '/api/version';

//价格
// const PRICE = 'https://api.coingecko.com/api/v3/simple/price';
  static var PRICE = 'https://boxwallet.app/api/price';

//绑定的域名
  static var NAME = 'https://mainnet.aeternity.io/middleware/names/reverse/';

//域名归属
  static var NAME_OWNER = '/v2/names/';

//兑换币种列表
  static var SWAP_COIN_LIST = baseHost! + '/api/swap/coin/list';

////兑换币种下用户挂单
  static var SWAP_COIN_ACCOUNT = baseHost! + '/api/swap/coin/account';

////兑换币种下正在挂单的
  static var SWAP_COIN_ACCOUNT_MY = baseHost! + '/api/swap/coin/account/my';

//兑换订单
  static var SWAP_COIN_ORDER_MY = baseHost! + '/api/swap/coin/order/my';

  static var AEX9_ALLOWANCE = baseHost! + '/api/aex9/allowance';

  static var APP_STORE = baseHost! + '/api/config/store';

  static var AEX9_RECORD = baseHost! + '/api/tokens/record';

//Cfx
  static var CFX_BALANCE = baseHost! + '/cfx/api/balance';
  static var CFX_TRANSACTION = baseHost! + '/cfx/api/transaction';
  static var CFX_TOKENS = baseHost! + '/cfx/api/tokens/list';
  static var CFX_TOKENS_ADDRESS = baseHost! + '/cfx/api/tokens/by-address';
  static var CFX_TRANSACTION_HASH = baseHost! + '/cfx/api/transaction/hash';
  static var CFX_CRC20_TRANSACTION_HASH = baseHost! + '/cfx/api/crc20/transaction';
  static var CFX_NFT_BALANCE = baseHost! + '/cfx/api/nft/balance';
  static var CFX_NFT_TOKEN = baseHost! + '/cfx/api/nft/token';
  static var CFX_NFT_PREVIEW = baseHost! + '/cfx/api/nft/preview';

//ETH
  static var ETH_TOKEN_LIST_ACTIVITY = baseHost! + '/eth/api/token_list/activity';
  static var ETH_TRANSFER_RECORD = baseHost! + '/eth/api/transaction_action/universal_list';
  static var ETH_TOKEN_HOT_LIST = baseHost! + '/eth/api/token/hot_list';
  static var ETH_TOKEN_SEARCH = baseHost! + '/eth/api/token/search';
  static var ETH_FEE = baseHost! + '/eth/api/block_chain/fee_list';
}
