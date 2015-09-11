//
//  ViewController.m
//  BKSingleton
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "ViewController.h"
#import "BKHelper.h"

@interface ViewController ()

@end

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
