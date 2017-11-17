//
//  ReachabilityHelper.h
//  HaiYiM+
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 John. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HY_NetworkStatus) {
    HY_NotReachable = 0,
    HY_ReachableViaWiFi = 2,
    HY_ReachableViaWWAN = 1,
    HY_ReachableVia_2G = 3,
    HY_ReachableVia_3G = 4,
    HY_ReachableVia_4G = 5,
};

typedef void (^HYNetWorkChanged)(HY_NetworkStatus netStatus);

@interface ReachabilityHelper : NSObject

@property (nonatomic,assign) HY_NetworkStatus netStatus;
@property (nonatomic,copy) HYNetWorkChanged netChangedBlock;

+(instancetype)shareReachabilityHelper;
-(void)initNetCheck;
-(HY_NetworkStatus)currentReachabilityStatus;
-(NSString *)currentReachabilityString;
@end
