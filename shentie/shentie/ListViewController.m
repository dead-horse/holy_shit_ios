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

@end

@implementation ListViewController
@synthesize listWebView = _listWebView;

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
    NSURL *url = [NSURL URLWithString:@"http://m.taobao.com"];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
