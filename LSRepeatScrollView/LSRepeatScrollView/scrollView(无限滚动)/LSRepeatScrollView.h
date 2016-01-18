//
//  LSRepeatScrollView.h
//  LSRepeatScrollView
//
//  Created by ls on 15/12/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSRepeatScrollView : UIView

@property (nonatomic, strong) NSMutableArray *images;
/*
 imageView点击回调
 */
@property (nonatomic, copy) void(^tapBlock)(NSInteger index);
@end
