//itunes更新版本
#define APP_LOOKUP_URL @"http://itunes.apple.com/lookup?id=994366529"

// 链接地址
#define EMPTY_URI @"http://localhost/"


#define MAIN_URL @"http://admin.yingtaoshe.com/index.php/api"
#define API_TOKEN @"5cf3365a5d783482c44b4a4b721bca1021c83a5f78ccebfb87c57dc8da5c9ec6"
#define API_URL @"http://admin.yingtaoshe.com/index.php/api"
#define domainURL @"http://admin.yingtaoshe.com"
#elif kTest
#define IS_PUSHTO_APPSTORE   1
#define kBugTagType  BTGInvocationEventBubble
//测试地址
#define MAIN_URL @"http://139.129.18.72/api"
#define API_TOKEN   @"42985d2f72c36a095f0ccdc0b4c9a69b7eb87dd32cdec77b014809ffa3cd0ea5"
#define API_URL @"http://139.129.18.72/api"
#define domainURL @"http://139.129.18.72"



#define HTPhone @"400-1630-666"
#define huadongtu @"0"

#define APP_ID          @"wx058a5abb7720ea82"               //APPID
#define APP_SECRET      @"d0b5b0c980fce630db44b9db52f78065" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1253359601"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"b28be4b8a68f4ff8abdcacbb3bdc042d"
//支付结果回调页面
#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"
#endif



//=======================================支付宝支付=================================================
http://www.jianshu.com/p/08e03fad2dca
http://www.jianshu.com/p/5ba888badebd
http://www.jianshu.com/p/97d38b00e53d

* 支付宝接口文档中写了3p参数列表，--！ 总结下我用的到，或者说是Demo中提到的，别的就超出范围了
* 合作者身份ID           alipayPartner = @"2088一串数字";
* 接口名称               alipaySeller = @"tianticar@126.com";
* 签名                  aliPayPrivateKey = @"很长很长的私钥";
//公钥                  alipayRSA_PUBLIC=@"一般长";  客户端不用服务器都给我了--~！
* 服务器异步通知页面路径   alipayNotifServerURL = @"一个网址"; //支付结果，支付宝会通知服务器


//.封装订单模型
AlixPayOrder *order = [[AlixPayOrder alloc] init];
// 生成订单描述
NSString *orderSpec = [order description];

//2.签名
id<DataSigner> signer = CreateRSADataSigner(@“私钥key”);
// 传入订单描述 进行 签名
NSString *signedString = [signer signString:orderSpec];


//3.生成订单字符串
NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                         orderSpec, signedString, @"RSA"];

//4.调用支付接口
AlixPay * alixpay = [AlixPay shared];
// appScheme：商户自己的协议头
int ret = [alixpay pay:orderString applicationScheme:appScheme];


1：先与支付宝签约，获得商户ID（partner）和账号ID（seller）
2：下载相应的公钥私钥文件（加密签名用）
3：下载支付宝SDK
4：生成订单信息
5：调用支付宝客户端，由支付宝客户端跟支付宝安全服务器打交道
6：支付完毕后返回支付结果给商户客户端和服务 ， SDK里有集成支付宝功能的一个Demo> 集成支付功能的具体操作方式，可以参考Demo

//=======================================微信支付=================================================
http://www.jianshu.com/p/c89e9d123d66
//微信支付:http://www.jianshu.com/p/c89e9d123d66

（1）：AppID
（2）：微信支付商户号
（4）：前往商户平台完成入驻
（4）：API秘钥（自己设置即可，注意一定要32位字母加数字的组合）记得保存好秘钥，以后要使用

1:下载证书
2:设置API秘钥

#define KWinXin @"App ID"  // 回调ID（Bundle ID）         //项目中自带的设置即可
/**************微信支付************/
#define APP_ID          @"APPID"   //APPID              //注册成功之后返回到邮箱的
#define APP_SECRET      @"App Secret" //appsecret ：     //注册时候显示的标志符
//商户号，填写商户对应参数
#define MCH_ID          @"商户ID"                        //商户设置的，根据注册之后返回邮箱的商户号对应
//商户API密钥，填写相应参数
#define PARTNER_ID      @"API秘钥"                       //注册的时候设置的，在下载证书页面
//支付结果回调页面
#define NOTIFY_URL      @"后台给你的支付成功之后回调的地址"   //后台提供的支付成功之后的回调地址
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php" //后台服务器支付数据的地址
/*****************微信支付***************/



//=======================================银联支付=================================================
http://www.jianshu.com/p/92d615f78509
http://www.jianshu.com/p/78d309a2c140




















