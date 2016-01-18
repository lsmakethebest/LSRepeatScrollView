

//
//  LSPageControl.m
//  
//
//  Created by ls on 15/12/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSPageControl.h"

@interface LSPageControl ()
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *defaultImage;

@end
@implementation LSPageControl
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.width=7;
    }
    return self;
}
- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    //此处可换成自己的图片
    if (self.currentImage==nil) {
        self.currentImage=[self imageWithColor:[UIColor yellowColor] isFill:NO width:self.width];
    }
    if (self.defaultImage==nil) {
        self.defaultImage=[self imageWithColor:[UIColor yellowColor] isFill:YES width:self.width];
    }
    for (int i = 0; i < self.subviews.count; i++) {
        UIView* view = self.subviews[i];
        if (i == currentPage) {
            view.backgroundColor = [UIColor colorWithPatternImage:self.currentImage];
        }
        else {
           view.backgroundColor = [UIColor colorWithPatternImage:self.defaultImage];
        }
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //如提供的图片过大可再次重写所有子控件frmae
    for (UIView *view in self.subviews) {
        CGRect rect=view.frame;
        rect.size=CGSizeMake(self.width, self.width);
        view.frame=rect;
    }
}
- (UIImage*)imageWithColor:(UIColor*)color isFill:(BOOL)isFill width:(CGFloat)width
{
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, width/2, width/2, width/2, 0, 2*M_PI, 0);
    [color set];
    if (isFill) {
        CGContextFillPath(context);
    }
    else {
        CGContextSetLineWidth(context,1);
        CGContextStrokePath(context);
    }
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end
