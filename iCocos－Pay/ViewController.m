//
//  ViewController.m
//  iCocos－Pay
//
//  Created by caolipeng on 15/11/4.
//  Copyright © 2015年 caolipeng. All rights reserved.
//


//获取当前系统版本
#define __ios9_0__ ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define __ios8_0__ ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define __ios7_0__ ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)


#import "ViewController.h"

#import "UIViewController+iCocosPayMethod.h"

#import "AliPayNeedDEF.h"

#import "payRequsestHandler.h"

#import "UPPayPlugin.h"

@interface ViewController ()<UPPayPluginDelegate>


@property (weak, nonatomic) IBOutlet UILabel *shopDesc;

@end

@implementation ViewController

////参数的传递（与设置）在AliPayNeedDEF.h中????????????????
/****************************  支付宝支付  *****************************/

/*-------------------------------------------------
 描述: 支付宝支付方法
 作用：直接调用，内部已经实现了所有业务逻辑
 参数：传对应的按钮：防止多种不同的支付方式
 补充：使用通知回调
 -------------------------------------------------*/
#pragma mark 之后按钮点击回调－－－－－－－－－－－－－－－－－－－－
- (IBAction)payWithAliPay:(id)sender {
    //这里调用我自己写的catagoary中的方法，方法里集成了支付宝支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
    //    [self payTHeMoneyUseAliPayWithOrderId:@"这里填写后台返回给你的订单id" totalMoney:@"这里填写钱数（单位/元）" payTitle:@"这里告诉客户花钱买了啥，力求简短"];
    
    
    [self payTHeMoneyUseAliPayWithOrderId:@"malipay" totalMoney:@"10" payTitle:@"购买商品信息介绍"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPayResultNoti:) name:ALI_PAY_RESULT object:nil];
}


#pragma mark 支付成功与失败回调－－－－－－－－－－－－－－－
//支付宝支付成功失败
-(void)AliPayResultNoti:(NSNotification *)noti
{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:ALIPAY_SUCCESSED]) {
        [self showMessage:@"支付成功"];
        //在这里填写支付成功之后你要做的事情
        
    }else{
        [self showMessage:@"支付失败"];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALI_PAY_RESULT object:nil];
}


////参数和对应的值直接在这里传递????????????????
/****************************  微信支付  *****************************/

/*-------------------------------------------------
 描述: 微信支付方法
 作用：直接调用，内部已经实现了所有业务逻辑
 参数：传对应的按钮：防止多种不同的支付方式
 补充：使用通知回调
 -------------------------------------------------*/
#pragma mark 之后按钮点击回调－－－－－－－－－－－－－－－－－－－－
- (IBAction)payWithWeChatPay:(id)sender {
    //这里调用我自己写的catagoary中的方法，方法里集成了微信支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
    //这里填写的两个参数是后台会返回给你的
    [self payTheMoneyUseWeChatPayWithPrepay_id:@"这里填写后台返回的Prepay_id" nonce_str:@"这里填写后台给你返回的nonce_str"];
    //所以这里添加一个监听，用来接收是否成功的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];
    
}

#pragma mark 支付成功与失败回调－－－－－－－－－－－－－－－
//微信支付付款成功失败
-(void)weChatPayResultNoti:(NSNotification *)noti{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:IS_SUCCESSED]) {
        [self showMessage:@"支付成功"];
        //在这里填写支付成功之后你要做的事情
        
    }else{
        [self showMessage:@"支付失败"];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
}



////参数和对应的值直接在这里传递????????????????
/****************************  银联支付  *****************************/

/*-------------------------------------------------
 描述: 银联支付方法
 作用：直接调用，内部已经实现了所有业务逻辑
 参数：传对应的按钮：防止多种不同的支付方式
 补充：使用代理方式回调
 -------------------------------------------------*/
#pragma mark 之后按钮点击回调－－－－－－－－－－－－－－－－－－－－
- (IBAction)payWithUPPay:(id)sender {
    
    
    NSLog(@"银联支付－－－－－－缺少订单号");
    
    return;
    
    NSString *tnNumber = @" "; //订单号
    NSString *tnMode = @"00"; //测试环境  上线时，请改为“00”
    
    //这里调用我自己写的catagoary中的方法，方法里集成了银联支付的步骤，并通过代理，用来传递是否支付成功的信息
    [self payTHeMoneyUseUPPayPluginWithTn:tnNumber mode:tnMode viewController:self delegate:self];
}


#pragma mark 支付成功与失败回调－－－－－－－－－－－－－－－
#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:@"%@", result];
    NSLog(@"msg%@",msg);
    
    if ([result isEqualToString:@"msgcancel"]) {
        NSLog(@"取消银联支付...");
    }
    else if([result containsString:@"success"]){
        NSLog(@"支付成功");
        
    }
}


/**
 *  提示框效果
 *
 *  @return 根据对应的支付状态提示相应的信息
 */
#pragma mark 提示框－－－－－－－－－－－－－－－－
- (void) showMessage:(NSString*)message{
    
    if (__ios9_0__) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
        });
    }
}

@end
