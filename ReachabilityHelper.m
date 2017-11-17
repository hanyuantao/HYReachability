//
//  ReachabilityHelper.m
//  HaiYiM+
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 John. All rights reserved.
//

#import "ReachabilityHelper.h"
#import "HY_Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@implementation ReachabilityHelper
static  ReachabilityHelper * reachability;

//创建单例
+(instancetype)shareReachabilityHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [[super allocWithZone:NULL] init] ;
        [reachability initNetCheck];
    });
    return reachability;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [ReachabilityHelper shareReachabilityHelper] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [ReachabilityHelper shareReachabilityHelper] ;
}


//初始网络监控
-(void)initNetCheck{
    //// 检测指定服务器是否可达
    //   NSString *remoteHostName = @"www.apple.com";
    //   HY_Reachability *hostReachability = [HY_Reachability reachabilityWithHostname:remoteHostName];
    HY_Reachability *hostReachability = [HY_Reachability reachabilityForInternetConnection];
    self.netStatus = (HY_NetworkStatus)hostReachability.currentReachabilityStatus;
    if (self.netStatus == HY_ReachableViaWWAN) {
        self.netStatus = [self netWorkType];
    }
    //有网络连接
    hostReachability.reachableBlock = ^(HY_Reachability * reachability)
    {
        if (reachability.currentReachabilityStatus == ReachableViaWWAN) {
//            self.netStatus = HY_ReachableViaWiFi;
            self.netStatus = [self netWorkType];
        }
        else if (reachability.currentReachabilityStatus == ReachableViaWiFi) {
            self.netStatus = HY_ReachableViaWiFi;
            NSLog(@"WIFI网络");
        }
    };
    //没有网络连接
    hostReachability.unreachableBlock = ^(HY_Reachability * reachability)
    {
        self.netStatus = HY_NotReachable;
        NSLog(@"无网络");
    };
    if (self.netChangedBlock) {
        self.netChangedBlock(self.netStatus);
    }
    [hostReachability startNotifier];
}

//获取移动网络类型
- (HY_NetworkStatus)netWorkType
{
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            return HY_ReachableVia_4G;
        } else if ([typeStrings3G containsObject:accessString]) {
            return HY_ReachableVia_3G;
        } else if ([typeStrings2G containsObject:accessString]) {
            return HY_ReachableVia_2G;
        } else {
            return HY_ReachableViaWWAN;
        }
    } else {
        return HY_ReachableViaWWAN;
    }
}

//获取网络状态
-(HY_NetworkStatus)currentReachabilityStatus
{
    return [ReachabilityHelper shareReachabilityHelper].netStatus;
}

-(NSString *)currentReachabilityString
{
    NSString *netString;
    HY_NetworkStatus status;
    if (self.netStatus) {
        status = self.netStatus;
    }else{
        status = [[ReachabilityHelper shareReachabilityHelper] netStatus];
    }
    switch (status) {
        case HY_NotReachable:
            netString = @"无网络";
            break;
        case HY_ReachableViaWWAN:
            netString = @"移动网络";
            break;
        case HY_ReachableVia_2G:
            netString = @"2G网络";
            break;
        case HY_ReachableVia_3G:
            netString = @"3G网络";
            break;
        case HY_ReachableVia_4G:
            netString = @"4G网络";
            break;
        default:
            break;
    }
    return netString;
}

@end
