//
//  UIViewController+iCocosPayMethod.m
//  iCocos－Pay
//
//  Created by caolipeng on 15/11/4.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

#import "UIViewController+iCocosPayMethod.h"

/**支付宝支付 */
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayNeedDEF.h"

/**微信支付*/
#import "WXApi.h"
#import "payRequsestHandler.h"


/** 银联支付*/
#include "UPPayPlugin.h"


@implementation UIViewController (iCocosPayMethod)

//===========================分割线==========================================================
/****************************  支付宝支付  *****************************/

-(void)payTHeMoneyUseAliPayWithOrderId:(NSString *)orderId totalMoney:(NSString *)totalMoney payTitle:(NSString *)payTitle
{
    NSMutableString *orderString = [NSMutableString string];
    [orderString appendFormat:@"service=\"%@\"", @"mobile.securitypay.pay"]; //
    [orderString appendFormat:@"&partner=\"%@\"", AliPartnerID];          //
    [orderString appendFormat:@"&_input_charset=\"%@\"", @"utf-8"];    //
    
    [orderString appendFormat:@"&notify_url=\"%@\"", AliNotifyURL];       //
    [orderString appendFormat:@"&out_trade_no=\"%@\"", orderId];   //
    [orderString appendFormat:@"&subject=\"%@\"", payTitle];        //
    [orderString appendFormat:@"&payment_type=\"%@\"", @"1"];          //
    [orderString appendFormat:@"&seller_id=\"%@\"", AliSellerID];         //
    [orderString appendFormat:@"&total_fee=\"%@\"", totalMoney];         //
    [orderString appendFormat:@"&body=\"%@\"", payTitle];              //
    [orderString appendFormat:@"&showUrl =\"%@\"", @"m.alipay.com"];
    
    
    id<DataSigner> signer = CreateRSADataSigner(AliPartnerPrivKey);
    NSString *signedString = [signer signString:orderString];
    
    [orderString appendFormat:@"&sign=\"%@\"", signedString];
    [orderString appendFormat:@"&sign_type=\"%@\"", @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kAliPayURLScheme callback:^(NSDictionary *resultDic)
     {
         NSLog(@"reslut = %@",resultDic);
         if ([[resultDic objectForKey:@"resultStatus"] isEqual:@"9000"]) {
             //支付成功
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_SUCCESSED];
             
         }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_FAILED];
         }
     }];
    
    
    /**
     *  如果没有安装支付宝，内部会自动判断，然后弹出一个网页实现支付
     */
#pragma mark 弹出网页支付需要在Appdelegate中实现对应的方法(需要先导入：#import <AlipaySDK/AlipaySDK.h>)
}

//===========================分割线==========================================================
/****************************  微信支付  *****************************/
/*-------------------------------------------------
 描述: <#这段代码的名称#>
 作用：<#这段代码有什么用处#>
 参数：<#这段代码重要参数的介绍#>
 prarms：
 #define kWeChatCallBackMethod @"mobileapi.goods.weixin_pay"
 
 （1）：AppID
 （2）：微信支付商户号
 （4）：前往商户平台完成入驻
 （4）：API秘钥（自己设置即可，注意一定要32位字母加数字的组合）记得保存好秘钥，以后要使用
 -------------------------------------------------*/
- (void)payTheMoneyUseWeChatPayWithPrepay_id:(NSString *)prepay_id nonce_str:(NSString *)nonce_str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",str);
    //调起微信支付···
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = MCH_ID;
    req.prepayId            = [NSString stringWithFormat:@"%@",prepay_id];
    req.nonceStr            = [NSString stringWithFormat:@"%@",nonce_str];
    req.timeStamp           = [str intValue];
    req.package             = @"Sign=WXpay";
    //创建支付签名对象
    payRequsestHandler *req1 =[[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req1 init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req1 setKey:PARTNER_ID];
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: APP_ID        forKey:@"appid"];
    [signParams setObject: [NSString stringWithFormat:@"%@",nonce_str]   forKey:@"noncestr"];
    [signParams setObject: @"Sign=WXpay"      forKey:@"package"];
    [signParams setObject: MCH_ID        forKey:@"partnerid"];
    [signParams setObject: [NSString stringWithFormat:@"%d",str.intValue]   forKey:@"timestamp"];
    [signParams setObject: [NSString stringWithFormat:@"%@",prepay_id]     forKey:@"prepayid"];
    //生成签名
    NSString *signStr  = [req1 createMd5Sign:signParams];
    NSLog(@"%@",signStr);
    req.sign                =signStr;
    NSLog(@"%@",req);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"weixin_pay_result" object:nil];
    [WXApi sendReq:req];
    
}

//微信付款成功失败
-(void)noti:(NSNotification *)noti{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:@"成功"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:IS_SUCCESSED];
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:IS_FAILED];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}

//？？？？？？？？预留使用???????????????
//===========================分割线==========================================================
/****************************  银联支付  *****************************/

/*-------------------------------------------------
 描述: 这段代码的名称
 作用：实现银联支付功能
 参数：需要传入的数据（服务器或则成品准备好了的）
 补充：注意对应参数的设置
 tn:NSString*(交易流水号信息，银联后台生成，通过商户后台返回到客户端并传入支付控件；)
 mode:NSString*(接入模式设定，两个值：@"00":代表接入生产环境（正式版本需要）；@"01"：代表接入开发测试环境（测试版本需要）；)
 viewController:UIViewController*(商户应用程序调用银联手机支付的当前UIViewController；)
 delegate:id<UPPayPluginDelegate>(实现UPPayPluginDelegate方法的UIViewController；)
 -------------------------------------------------*/
-(void)payTHeMoneyUseUPPayPluginWithTn:(NSString *)tn mode:(NSString *)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate
{
    [UPPayPlugin startPay:tn mode:mode viewController:viewController delegate:delegate];
}



@end
