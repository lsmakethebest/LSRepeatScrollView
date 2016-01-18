

//
//  LSNavigationController.m
//  LSRepeatScrollView
//
//  Created by ls on 16/1/15.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSNavigationController.h"

@implementation LSNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        UIGestureRecognizer* gesture = self.interactivePopGestureRecognizer;
        UIView* view = gesture.view;
        NSMutableArray* targets = [gesture valueForKey:@"_targets"];
        id gestureRecognizerTarget = targets.firstObject;
        id target=[gestureRecognizerTarget valueForKey:@"_target"];
        SEL action=NSSelectorFromString(@"handleNavigationTransition");
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:target action:action];
        [view addGestureRecognizer:pan];
    });
}

@end
