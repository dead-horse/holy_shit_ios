//
//  ListViewController.m
//  shentie
//
//  Created by he yiyu on 13-12-1.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import "ListViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "DetailViewController.h"

@interface ListViewController ()
- (void)sendMessage:(NSString *)key message:(NSDictionary *)data;
- (void)dispatchMessage: (NSString *)key message:(NSDictionary *)data;
@property (strong, nonatomic)NSDictionary *selectedPost;
@property (strong, nonatomic)UIImageView *loadingImageView;

@end

@implementation ListViewController
@synthesize listWebView = _listWebView;
@synthesize listContainerView = _listContainerView;
@synthesize selectedPost = _selectedPost;
@synthesize loadingImageView = _loadingImageView;

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        NSString *launchImageName = SCREEN_HEIGHT > 480.0f ?
        @"LaunchImage-700-568h" : @"LaunchImage-700";
        UIImage *loadingImage = [UIImage imageNamed:launchImageName];
        _loadingImageView = [[UIImageView alloc] initWithImage:loadingImage];
        _loadingImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _loadingImageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupStyle {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)setLoadingImage {
    [self.view addSubview:self.loadingImageView];
}

- (void) removeLoadingImage {
    [self.loadingImageView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupStyle];
    self.listWebView.scalesPageToFit = YES;
    self.listWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:LIST_URL];
    NSURLRequest *reqObj = [NSURLRequest requestWithURL:url];
    [self.listWebView loadRequest:reqObj];
    [self setLoadingImage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self removeLoadingImage];
    
    //remove all cached post
    [Cache removeAllValueByCat:POSTS_PREFIX];
    //注入message.js脚本
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:script];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"出了什么错？%@", error);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    NSLog(@"访问地址%@", url);
    if ([url.scheme isEqualToString:@"bridge"]) {
        NSString *event = url.host;
        NSDictionary *data = [[url.path substringFromIndex:1] objectFromJSONString];
        [self dispatchMessage:event message:data];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma bridage
- (void)sendMessage:(NSString *)key message:(NSDictionary *)data {
    NSString *js = [NSString stringWithFormat:@"window.bridge.dispatch('%@', %@);", key, [data JSONString]];
    NSLog(@"js string: %@", js);
    [self.listWebView stringByEvaluatingJavaScriptFromString:js];
}

- (void)dispatchMessage:(NSString *)key message:(NSDictionary *)data {
    NSLog(@"分发消息, Key: %@, Value: %@", key, [data JSONString]);
    if ([key isEqualToString:@"openPost"]) {
        self.selectedPost = [data copy];
        [self performSegueWithIdentifier:@"listToDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *target = segue.destinationViewController;
    [target setupData:self.selectedPost];
}


@end
