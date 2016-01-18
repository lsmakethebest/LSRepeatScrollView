

//
//  LSRepeatScrollView.m
//  LSRepeatScrollView
//
//  Created by ls on 15/12/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSRepeatScrollView.h"
#import "LSImageModel.h"
#import "UIImageView+WebCache.h"
#import "LSPageControl.h"
#define Width self.frame.size.width
#define Height self.frame.size.height
@interface LSRepeatScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) UIImageView* leftImageView;
@property (nonatomic, weak) UIImageView* midImageView;
@property (nonatomic, weak) UIImageView* rightImageView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,weak) UIPageControl * pageControl;
@property (nonatomic, assign) CGFloat animationTime;

@end

@implementation LSRepeatScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        self.animationTime=2.0;
        self.currentPage = 0;
        //进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}
- (void)initViews
{
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    LSPageControl *pageControl=[[LSPageControl alloc]init];
    [self addSubview:pageControl];
    self.pageControl=pageControl;
    
    self.leftImageView = [self addImageView];
    self.midImageView = [self addImageView];
    self.rightImageView = [self addImageView];
    
    //    self.leftImageView.backgroundColor = [UIColor orangeColor];
    //    self.midImageView.backgroundColor = [UIColor lightGrayColor];
    //    self.rightImageView.backgroundColor = [UIColor whiteColor];
}

- (UIImageView*)addImageView
{
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapClick:)];
    [imageView addGestureRecognizer:tap];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView];
    return imageView;
}
- (void)setImages:(NSMutableArray*)images
{
    _images = images;
    self.pageControl.numberOfPages=images.count;
    self.pageControl.currentPage=self.currentPage;
    [self setImageViewsFrame];
    [self relodata];
    [self startTimer];
    
}
- (void)setImageViewsFrame
{
    self.leftImageView.frame = CGRectMake(0, 0, Width, Height);
    self.midImageView.frame = CGRectMake(Width, 0, Width, Height);
    self.rightImageView.frame = CGRectMake(Width * 2, 0, Width, Height);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGFloat x = point.x;
    if (self.images!=nil&& x >= Width * 2) {
        self.currentPage++;
        if (self.currentPage == self.images.count) {
            self.currentPage = 0;
        }
        UIImageView* tmp = self.leftImageView;
        self.leftImageView = self.midImageView;
        self.midImageView = self.rightImageView;
        self.rightImageView = tmp;
        point.x = Width;
        [self.scrollView setContentOffset:point];
        [self setImageViewsFrame];
        [self relodata];
    }
    else if (self.images!=nil&&x <=0) {
        self.currentPage--;
        if (self.currentPage == -1) {
            self.currentPage = self.images.count - 1;
        }
        UIImageView* tmp = self.rightImageView;
        self.rightImageView = self.midImageView;
        self.midImageView = self.leftImageView;
        self.leftImageView = tmp;
        point.x = Width;
        [self.scrollView setContentOffset:point];
        [self setImageViewsFrame];
        [self relodata];
    }
    self.pageControl.currentPage=self.currentPage;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [self stopTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
/*
 刷新图片
 */
- (void)relodata
{
    LSImageModel* model1;
    if (self.currentPage == 0) {
        model1 = self.images[self.images.count - 1];
    }
    else {
        model1 = self.images[self.currentPage - 1];
    }
    [self.leftImageView setImageWithURL:model1.imageUrl placeholderImage:nil];
    
    LSImageModel* model2 = self.images[self.currentPage];
    [self.midImageView setImageWithURL:model2.imageUrl placeholderImage:nil];
    
    LSImageModel* model3;
    if (self.currentPage == self.images.count - 1) {
        model3 = self.images[0];
    }
    else {
        model3 = self.images[self.currentPage + 1];
    }
    [self.rightImageView setImageWithURL:model3.imageUrl placeholderImage:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat pageHeight=30;
    self.pageControl.frame=CGRectMake(0, Height-pageHeight, Width, pageHeight);
    if (self.images.count>1) {
        self.scrollView.contentSize = CGSizeMake(Width * 3, 0);
    }
    self.pageControl.hidden=!(self.images.count>1);
    [self.scrollView setContentOffset:CGPointMake(Width, 0)];
}
/*
 图片点击
 */
-(void)tapClick:(UITapGestureRecognizer*)tap
{
    if (self.tapBlock) {
        self.tapBlock(self.currentPage);
    }
    //    NSLog(@"当前页数====%ld",self.currentPage);
    
}
-(void)stopTimer
{
    [self.timer invalidate];
    self.timer=nil;
}
/*
 开启定时器
 */
-(void)startTimer
{
    if (self.images.count==1) return;
    if (self.timer==nil) {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:self.animationTime target:self selector:@selector(autoRepeat) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
-(void)autoRepeat
{
    [self.scrollView setContentOffset:CGRectMake(2*Width, 0, Width, Height) animated:YES]
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
