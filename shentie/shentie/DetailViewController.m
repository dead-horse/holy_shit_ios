//
//  DetailViewController.m
//  shentie
//
//  Created by he yiyu on 13-12-2.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import "DetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PostsRequest.h"

@interface DetailViewController ()
@property (nonatomic, strong) PostsRequest *postsRequest;
@property (nonatomic, strong) NSMutableDictionary *post;
@property BOOL hasPostGood;
@end

@implementation DetailViewController
@synthesize detailWebView = _detailWebView;
@synthesize detailContainerView = _detailContainerView;
@synthesize postsRequest = _postsRequest;
@synthesize post = _post;

- (PostsRequest *)postsRequest {
    if (!_postsRequest) {
        _postsRequest = [[PostsRequest alloc] init];
        _postsRequest.delegate = self;
    }
    return _postsRequest;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupData:(NSDictionary *)data {
    if (!data[@"id"]) {
        return;
    }
    //get from cache
    NSDictionary *cacheValue = [Cache getValueByKey:[data[@"id"] stringValue] andCat:POSTS_PREFIX];
    if (cacheValue) {
        self.post = [cacheValue mutableCopy];
    } else {
        self.post = [data mutableCopy];
        [Cache setValue:data withKey:[data[@"id"] stringValue] andCat:POSTS_PREFIX];
    }
}

- (void)setupStyle {

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIColor *barColour = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.00f];
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        UIView *barView = [[UIView alloc] initWithFrame:statusBarFrame];
        barView.opaque = NO;
        barView.alpha = 1.0f;
        barView.backgroundColor = barColour;
        [self.detailContainerView addSubview:barView];
        self.detailWebView.frame = CGRectMake(0,
                                              self.detailWebView.frame.origin.y - 20,
                                              self.detailWebView.frame.size.width,
                                              self.detailWebView.frame.size.height + 20);
    }
    UIColor *controllerContainerColour = [UIColor colorWithRed:0 green:219 / 255.0 blue: 222 / 255.0 alpha:1.00f];
    self.controllerContainerView.backgroundColor = controllerContainerColour;
    
    self.goodLabel.text = [NSString stringWithFormat:@"%@", self.post[@"good_num"]];
}

- (void)initControllerBar {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //must have url and id
    if (!self.post[@"url"] || !self.post[@"id"]) {
        return;
    }
    [self setupStyle];
    
    //start webview
    self.detailWebView.scalesPageToFit = YES;
    self.detailWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.post[@"url"]];
    NSURLRequest *reqObj = [NSURLRequest requestWithURL:url];
    [self.detailWebView loadRequest:reqObj];
    
    [self.postsRequest postViewById:self.post[@"id"]];
    
    [MBProgressHUD showHUDAddedTo:self.detailWebView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.detailWebView animated:YES];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    
    //注入message.js脚本
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:script];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goodBtnClick:(id)sender {
    if (!self.hasPostGood) {
        [self.postsRequest postGoodById:self.post[@"id"]];
        self.hasPostGood = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// posts request delegate
- (void)postGoodByIdCallback:(NSDictionary *)result error:(NSError *)err {
    if (err) {
        NSLog(@"get error when post good, %@", err);
        return;
    }
    NSNumber *goodNum = [NSNumber numberWithInt:[self.post[@"good_num"] intValue] + 1];
    //change the cache
    self.post[@"good_num"] = goodNum;
    self.goodLabel.text = [NSString stringWithFormat:@"%@", goodNum];
    [Cache setValue:[self.post copy] withKey:[self.post[@"id"] stringValue] andCat:POSTS_PREFIX];
}

- (void)postViewByIdCallback:(NSDictionary *)result error:(NSError *)err {
    if (err) {
        NSLog(@"get error when post good, %@", err);
        return;
    }
}
@end
