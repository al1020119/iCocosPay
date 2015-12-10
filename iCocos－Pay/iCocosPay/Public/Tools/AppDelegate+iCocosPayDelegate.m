//
//  AppDelegate+iCocosPayDelegate.m
//  iCocos－Pay
//
//  Created by caolipeng on 15/11/4.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

#import "AppDelegate+iCocosPayDelegate.h"

/** 支付宝支付 */
#import <AlipaySDK/AlipaySDK.h>


/** 微信支付*/
#import "WXApi.h"
#import "payRequsestHandler.h"

@interface AppDelegate ()<WXApiDelegate>



@end


@implementation AppDelegate (iCocosPayDelegate)




//===========================分割线==========================================================

/****************************  支付宝支付  *****************************/

/**
 *  支付宝支付代理方法
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    
    
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else
    {
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
        //        return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
        return YES;
    }
    
    return YES;
}
//===========================分割线==========================================================

/****************************  微信支付  *****************************/
/**
 *  微信支付代理方法
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /** 注册 */
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    
    return YES;
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法
-(void) onResp:(BaseResp*)resp
{
    //这里判断回调信息是否为 支付
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                //如果支付成功的话，全局发送一个通知，支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"成功"];
                break;
                
            default:
                //如果支付失败的话，全局发送一个通知，支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{
//        return [ShareSDK handleOpenURL:url wxDelegate:self];
        return YES;
    }
}

/**   同样在支付宝支付对应的方法中实现下面的代码  */
/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else
    {
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
//        return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
        return YES;
    }
}
*/


//需要先在代理启动的方法中注册支付

//===========================分割线==========================================================

/****************************  银联支付  *****************************/




@end
