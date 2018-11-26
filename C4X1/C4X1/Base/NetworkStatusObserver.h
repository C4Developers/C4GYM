//
//  NetworkStatus.h
//  C4X1
//
//  Created by 冯宇 on 2018/11/25.
//  Copyright © 2018 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkStatusObserver : NSObject

+ (instancetype)shareObserver;

/**
 开始监听WiFi的变化
 */
- (void)startObserve;

/**
 停止监听WiFi的变化
 */
- (void)stopObserve;

@end

NS_ASSUME_NONNULL_END
