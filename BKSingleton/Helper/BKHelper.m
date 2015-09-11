//
//  BKHelper.m
//  BKSingleton
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BKHelper.h"

// 四种组合方式
#define TestShareForSynchronized (NO)
#define TestAllocForSynchronized (YES)

static BKHelper *shareInstance = nil;

@implementation BKHelper
#pragma mark - singleton
+ (instancetype)shareHelper
{
    #ifdef TestShareForSynchronized
        [self shareHelperForSynchronized];
    #else
        [self shareHelperForDispatch_once];
    #endif
    
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    #ifdef TestAllocForSynchronized
        [self allocWithZoneForSynchronized:zone];
    #else
        [self allocWithZoneForDispatch_once:zone];
    #endif
    
    return shareInstance;
}

#pragma mark - private methods
+ (void)shareHelperForSynchronized
{
    @synchronized(self)
    {
        if (shareInstance == nil)
        {
            shareInstance = [[self alloc] init];
        }
    }
}

+ (void)shareHelperForDispatch_once
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        shareInstance = [[self alloc] init];
    });
}

+ (void)allocWithZoneForSynchronized:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareInstance == nil)
        {
            shareInstance = [super allocWithZone:zone];
        }
    }
}

+ (void)allocWithZoneForDispatch_once:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        shareInstance = [super allocWithZone:zone];
    });
}

@end
