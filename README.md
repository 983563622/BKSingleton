# BKSingleton

单例定义(ARC环境)

## Description

本Demo集成了ARC环境下单例定义的4种方式

## Features

1. 集成了单例定义的4方式

2. synchronized/dispatch_once的自由组合

## 四种组合方式

```objective-c

定义一个静态(文件内部访问)变量
static BKHelper *shareInstance = nil;

添加自由组合开关
// 四种组合方式
#define TestShareForSynchronized (YES)
#define TestAllocForSynchronized (YES)

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

```

## 测试方法及其结果:
```objective-c
@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BKLog(@"%@", [BKHelper shareHelper]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        BKLog(@"%@", [BKHelper shareHelper]);
    });
    
    BKLog(@"%@", [[BKHelper alloc] init]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        BKLog(@"%@", [[BKHelper alloc] init]);
    });
    
}
@end
```

`输出结果`:
```objective-c
2015-09-11 13:49:53.255 BKSingleton[14207:147064] -[ViewController viewDidLoad] <BKHelper: 0x7fa23248e650>
2015-09-11 13:49:53.256 BKSingleton[14207:147064] -[ViewController viewDidLoad] <BKHelper: 0x7fa23248e650>
2015-09-11 13:49:53.256 BKSingleton[14207:147189] __29-[ViewController viewDidLoad]_block_invoke <BKHelper: 0x7fa23248e650>
2015-09-11 13:49:53.256 BKSingleton[14207:147189] __29-[ViewController viewDidLoad]_block_invoke_2 <BKHelper: 0x7fa23248e650>
```

## Requirements

| BKSingleton Version | Minimum iOS Target  | Minimum OS X Target  |                                   Notes                                   |
|:--------------------:|:---------------------------:|:----------------------------:|:-------------------------------------------------------------------------:|
|          1.x         |            iOS 7            |           OS X 10.9          |        |                                                                           |

