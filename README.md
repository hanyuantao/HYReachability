# HYReachability
## 用法

1. 网络状态
typedef NS_ENUM(NSInteger, HY_NetworkStatus) {
HY_NotReachable = 0,
HY_ReachableViaWiFi = 2,
HY_ReachableViaWWAN = 1,
HY_ReachableVia_2G = 3,
HY_ReachableVia_3G = 4,
HY_ReachableVia_4G = 5,
};

2. 用法

ReachabilityHelper * reachHelper = [ReachabilityHelper shareReachabilityHelper];
HY_NetworkStatus status = [reachHelper currentReachabilityStatus];//获取当前状态

HY_NetworkStatus status = [reachHelper currentReachabilityString];//获取当前状态文字

//检测网络变化
reachHelper.netChangedBlock = ^(HY_NetworkStatus netStatus) {
    ...
};

