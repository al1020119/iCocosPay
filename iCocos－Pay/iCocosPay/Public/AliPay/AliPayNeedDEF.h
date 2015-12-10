//
//  AliPayNeedDEF.h
//  WeChatAndAliPayDemo
//
//  Created by iCocos on 15/10/21.
//  Copyright © 2015年 iCocos. All rights reserved.
//

#ifndef AliPayNeedDEF_h
#define AliPayNeedDEF_h

#import <AlipaySDK/AlipaySDK.h>

/**
 *  商户ID
 */
//合作身份者id，以2088开头的16位纯数字（客户给）
#define AliPartnerID @"b28be4b8a68f4ff8abdcacbb3bdc042d"

/**
 *  账户
 */
//收款支付宝账号
#define AliSellerID  @"1253359601"

/**
 *  私钥
 */
//商户私钥，自助生成（这个私钥需要自己手动生成，具体生成方法可以看支付宝的官方文档，下面给出大体格式）
#define AliPartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMJIujTSdNBrYHZEv+5lSMNKK+oORdjhFWnhqsWZil5EHeMdbUpALTp1QQeEJPgzE9aPC+YzweiV2CFOIjGEq2/taO3iWC9FZi0hlbN11GpbFVvhAZnouznwYPoO6y8ekeJlpqH2OUrJuwyL7Bq4ATyukuvhftuawxQ25SuvBw9pAgMBAAECgYARTcLv43KuAXJE9liV1gWGBzwkC4NjDqEGnifEk6lEPhLfYIaUX2Tn2PuivL1CMeJpcLIhnah+m6H1TW00NdnC5XvCvR7puD51nPrdDVkXZrORHVTn1qerQsHoL6vprbl8858DIXLrxDnM9dojuBd2k0ygb54MuhL7CpR2pwgtRQJBAOuwheM5yJq4khe4U0uLcU7C5iKfmzPMGyKNSzMggO8Li1NnxX6O6BYDS8PUAAhSDzC1xeyHzAhKaXxTQoFJd4cCQQDTBsVgMS3oSn4SqMnPZ5jJ4OAaqNGCH8NA3ATAVQmaF7575sLVhQ2F566NRqgTJYWGfru4xTkOeJ40YsDOtR2PAkEAgetWgoDxwcgIUCb9U2FUXlQ1Q9SzWwQh2RQF5fL+38Z/UMSdKzxfVvMOKq6MLgn98Z3hspbQs6lBKJVEzbvPtQJBALIWFb2O40oUi36duOnyaGt9/kIhU+V3fqSeyNezLA5BmXwgiy38QiROF+2bwj2ePaf6DdvpfLQssH5PFJ2dFRsCQFwU5PM8P/Oc96UM6Z8XEPe7bNjcQtHTvEjThWV4NdJpSSkLg0w4nKwJEl8B1crpzRtigoMHcRFeKBSYr/7peYk="

/**
 *  后台接口地址
 */
//后台给的接口网址
#define AliNotifyURL @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"   //这里填写你们的后台给你的支付接口网址

#define kAliPayURLScheme @"iCocosPay"  //AliPayURLScheme

//通知的名字及参数
#define ALI_PAY_RESULT   @"Ali_pay_result_isSuccessed"
#define ALIPAY_SUCCESSED    @"Ali_pay_isSuccessed"
#define ALIPAY_FAILED       @"Ali_pay_isFailed"

#endif /* AliPayNeedDEF_h */
