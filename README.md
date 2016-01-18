# LSRepeatScrollView
图片轮播器


    LSRepeatScrollView* repeatView = [[LSRepeatScrollView alloc] init];

    repeatView.frame = CGRectMake(50, 50, 300, 200);
    [self.view addSubview:repeatView];
    self.repeatView = repeatView;

    //此处是随便演示的一个点击事件，可以根据需求来任意修改
    UIWebView* webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor lightGrayColor];
    webView.frame = CGRectMake(0, 300, self.view.frame.size.width, 300);
    [self.view addSubview:webView];
    __weak typeof(self) weakSelf = self;
    repeatView.tapBlock = ^(NSInteger index) {
        NSLog(@"index==%ld", index);
        LSImageModel* model = weakSelf.images[index];
        [webView loadRequest:[NSURLRequest requestWithURL:model.imageUrl]];
    };
    
    //添加图片模型到数组 LSImageModel 包括imageUrl 和 jumpUrl
    LSImageModel* model1 = [[LSImageModel alloc] init];
    model1.imageUrl = [NSURL URLWithString:@"http://www.pptbz.com/Soft/UploadSoft/200911/2009110522430362.jpg"];
    [self.images addObject:model1];

    LSImageModel* model2 = [[LSImageModel alloc] init];
    model2.imageUrl = [NSURL URLWithString:@"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg"];
    [self.images addObject:model2];

    LSImageModel* model3 = [[LSImageModel alloc] init];
    model3.imageUrl = [NSURL URLWithString:@"http://pic28.nipic.com/20130402/9252150_190139450381_2.jpg"];
    [self.images addObject:model3];

    LSImageModel* model4 = [[LSImageModel alloc] init];
    model4.imageUrl = [NSURL URLWithString:@"http://c.hiphotos.baidu.com/zhidao/pic/item/1ad5ad6eddc451da6bb0d76fb6fd5266d11632f4.jpg"];

    [self.images addObject:model4];
    repeatView.images = self.images;
