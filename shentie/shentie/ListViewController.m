//
//  ListViewController.m
//  shentie
//
//  Created by he yiyu on 13-12-1.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import "ListViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ListViewController ()
@property (strong, nonatomic) NSMutableDictionary *callbacks;
- (void)sendMessage:(NSString *)key message:(NSDictionary *)data;
- (void)dispatchMessage: (NSString *)key message:(NSDictionary *)data;
- (void)onMessage:(NSString *)key handle:(BridageCallback)callback;
@end

@implementation ListViewController
@synthesize listWebView = _listWebView;
@synthesize callbacks = _callbacks;

- (NSMutableDictionary *)callbacks {
    if (!_callbacks) {
        _callbacks = [NSMutableDictionary dictionary];
    }
    return _callbacks;
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
        self.listWebView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    } else {
        self.listWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.listWebView.scalesPageToFit = YES;
    self.listWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:LIST_URL];
    NSURLRequest *reqObj = [NSURLRequest requestWithURL:url];
    [self.listWebView loadRequest:reqObj];
    [MBProgressHUD showHUDAddedTo:self.listWebView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupStyle];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.listWebView animated:YES];

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

- (void)onMessage:(NSString *)key handle:(BridageCallback)callback {
    if (callback) {
        NSLog(@"绑定消息%@", key);
        self.callbacks[key] = [callback copy];
    }
}

- (void)dispatchMessage:(NSString *)key message:(NSDictionary *)data {
    NSLog(@"分发消息, Key: %@, Value: %@", key, [data JSONString]);
    BridageCallback callback = self.callbacks[key];
    if (callback) {
        callback(data);
    }
}


@end
