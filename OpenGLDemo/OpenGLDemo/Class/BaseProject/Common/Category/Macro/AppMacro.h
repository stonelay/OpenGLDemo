//
//  AppMacro.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#import "ZLThemeControl.h"
#import "ZLNavigationService.h"
#import "UserInfoService.h"

#import "ApplicationEntity.h"


typedef NSString *NSStringKeyJT NS_EXTENSIBLE_STRING_ENUM;

#define NUMALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


#define AppScheme           @"jietiao"
#define AppSchemeCompeled   @"jietiao://"

// app
#define LoginHost           @"login"
#define TradePwdSetHost     @"payPwdSet"
#define MainHost            @"main"
#define ForgotPwdHost       @"forgotPwd"
#define TradePwdModifyHost  @"forgotTradePwd"
#define TradePwdModifyByBCHost @"TradePwdModifyByBC"
#define SettingHost         @"setting"
#define RiskReportListHost  @"riskReportList"

#define FeedBackHost        @"feedback"
#define FeedBackListHost    @"feedbackList"
#define AbountUsHost        @"abountUs"

// 支付 提现 充值 相关
#define yueHost             @"yue"
#define RechargeHost        @"recharge"
#define WithdrawHost        @"withdraw"
#define PaymentsHost        @"payments"
#define RechargeSuccessHost @"rechargeSuccess" // 充值成功
#define WithdrawSuccessHost @"withdrawSuccess" // 提现成功
#define RepaySuccessHost    @"repaySuccess" //还款成功
#define OrderDetailHost     @"orderDetail"
#define OfferMoneyHost      @"offerMoney"

// attach module
#define CouponHost          @"coupon"
#define CouponSelectHost    @"couponSelect"
#define CouponHisHost       @"couponHis"
#define UrgeHost            @"urge"
#define MessageHost         @"message"
#define MessageDetailHost   @"messageDetail"
#define ReviewHisHost       @"reviewHis"
#define FavHost             @"fav"

// bankcard module
#define VerifyBankCardHost  @"verifyBankCard"
#define VerifyBankCardListHost @"verifyBankListCard"
#define AddBankCardHost     @"addBankCard"
#define BankCardListHost    @"bankCardList"

// prove module
#define IDProveHost         @"idProve"
#define RelationProveHost   @"relationProve"
#define OperationHost       @"operationProve"
#define IDRecoHost          @"idReco"
#define ShowIDHost          @"showId"

#define HighProve           @"highProve"

// loan module
#define RepayHost           @"repay"  // 还款
#define RecoverHost         @"recover" // 回收借款
#define NeedRepayDetailHost @"needRepayDetail" // 未还款 应还金额
#define NeedRecoverDetailHost       @"needRecoverDetail" // 未回收借款 应还金额
#define AlreadyRepayDetailHost      @"alreadyRepayDetail" // 已还款 还款信息
#define AlreadyRecoverDetailHost    @"alreadyRecoverDetail" // 已回收借款 应还信息
#define LoanDetailHost      @"loanDetail"
#define PublishingHost      @"publishing"       // 自己发布的 借款
#define OtherPublishingHost @"otherPublishing"  // 平台上发布的 借款
#define PublishingListHost  @"publishingList"   // 自己发布的借款 列表
#define LoanSuccessHost     @"loanSuccessList"  // 借出 成功
#define RiskReportHost      @"riskReport"

#define ProblemHost         @"problem"

#define FeedBackListHost    @"feedbackList"



#define VisitedHost         @"visited"

#define QRCodeHost          @"qrcode"

#define HomeHost            @"home"
#define MineHost            @"mine"
#define LoanHost            @"loan"


#define PopCtrlHost         @"PopCtrlHost"
#define PopRootCtrlHost     @"PopRootCtrlHost"

#define RegistHost          @"regist"

#define BecomeMemberHost    @"becomeMember"
//#define SettingHost         @"setting"
#define ChangeGender        @"changeGender"
#define ChangeNick          @"changeNick"


// mall
#define MyCollection        @"myCollection"
#define MallOrderList       @"mallOrderList"
#define MallCart            @"mallCart"
#define PointDetail         @"pointDetail"

#define MallItem            @"mallItem"
#define CateWall            @"cateWall"
#define MallShop            @"mallShop"

// unknow
#define TopUpHost           @"topUp"


#define _SConnect(x, y) [NSString stringWithFormat:@"%@%@", x,y]
#define SConnect(x, y) _SConnect(x, y)

#define LocalAppHost(x) SConnect(@"jietiao://", x)

#endif /* AppMacro_h */
