//
//  NetworkStatus.m
//  C4X1
//
//  Created by 冯宇 on 2018/11/25.
//  Copyright © 2018 冯宇. All rights reserved.
//

#import "NetworkStatusObserver.h"
#import "Reachability.h"
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#define ChangeWiFiNoti @"com.apple.system.config.network_change"
#define NSOLOG(str) NSLog(@"NetworkStatusObserver：%@",str);

@interface NetworkStatusObserver()

// 监听WiFi变化相关的类
@property (nonatomic, strong) Reachability *hostReachability;

@end

@implementation NetworkStatusObserver

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    static NetworkStatusObserver *share;
    dispatch_once(&onceToken, ^{
        share = [[super allocWithZone:NULL] init];
    });
    return share;
}

+ (instancetype)shareObserver{
    return [[self alloc] init];
}

static void onNotifyCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    NSString* notifyName = (__bridge NSString *)name;//(NSString*)name;
    // WiFi之间的切换
    if ([notifyName isEqualToString:ChangeWiFiNoti]) {
        NSOLOG([[NetworkStatusObserver shareObserver] getWifiName]);
    }
}

- (NSString *)getWifiName {
    NSString * wifiName = @"未连接";
    NSArray * array = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    if (array.count > 0) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)(array.firstObject)));
        if ([info.allKeys containsObject:@"SSID"]) {
            wifiName = [info valueForKey:@"SSID"];
            NSLog(@"wifiName:%@", wifiName);
        }
    }
    return wifiName;
}

- (void)startObserve{
    //1.监听WiFi之间的切换
    CFStringRef name = (CFStringRef)ChangeWiFiNoti;
    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(center,NULL,onNotifyCallback, name, NULL,CFNotificationSuspensionBehaviorDeliverImmediately);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //2.监听WiFi与4G等其他网络之间的切换
    NSString * remoteHostName = @"www.baidu.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
}


- (void)reachabilityChanged:(NSNotification *)noti{
    Reachability* curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

-(void)updateInterfaceWithReachability:(Reachability *)reachability{
    if (reachability == self.hostReachability){
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus){
            case NotReachable: NSOLOG(@"断网"); break;
            case ReachableViaWWAN: NSOLOG(@"WWAN"); break;
            case ReachableViaWiFi: NSOLOG(@"Wi-Fi"); break;
        }
    }
}

// 移除通知
- (void)stopObserve{
    CFStringRef name = CFSTR("com.apple.system.config.network_change");
    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterRemoveObserver(center, NULL, name, NULL);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
