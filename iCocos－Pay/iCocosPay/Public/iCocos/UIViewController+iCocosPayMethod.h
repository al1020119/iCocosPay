//
//  UIViewController+iCocosPayMethod.h
//  iCocos－Pay
//
//  Created by caolipeng on 15/11/4.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UPPayPlugin.h"

@interface UIViewController (iCocosPayMethod)



- (void)payTheMoneyUseWeChatPayWithPrepay_id:(NSString *)prepay_id nonce_str:(NSString *)nonce_str;

-(void)payTHeMoneyUseAliPayWithOrderId:(NSString *)orderId totalMoney:(NSString *)totalMoney payTitle:(NSString *)payTitle;

-(void)payTHeMoneyUseUPPayPluginWithTn:(NSString *)tn mode:(NSString *)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;

@end
