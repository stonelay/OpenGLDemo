//
//  NotificationMacro.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/21.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

/** notification **/
#pragma mark - notification
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]

#define kNotificationUserLogin          @"kNotificationUserLogin"
#define kNotificationUserLogout         @"kNotificationUserLogout"

#define kNotificationBankCardChange     @"kNotificationBankCardChange"
#define kNotificationSelectCoupon       @"kNotificationSelectCoupon"

#define kNotificationUpdateUserData     @"kNotificationUpdateUserData"  // 更新用户 余额等数据
#define kNotificationUpdateLoanData     @"kNotificationUpdateLoanData"  // 更新首页借款数据
#define kNotificationUpdateOwnLoan      @"kNotificationUpdateOwnLoan"  // 更新借款信息

#define kNotificationUpdateMsgSum       @"kNotificationUpdateMsgSum"  // 更新消息

#endif /* NotificationMacro_h */
