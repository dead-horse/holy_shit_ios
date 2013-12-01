//
//  ListViewController.m
//  shentie
//
//  Created by he yiyu on 13-12-1.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import "ListViewController.h"

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
        [self.listWebView setBounds:CGRectMake(0,
                                            20,
                                            self.listWebView.frame.size.width,
                                            self.listWebView.frame.size.height - 20)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupStyle];
    
    self.listWebView.scalesPageToFit = YES;
    self.listWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://m.taobao.com"];
    NSURLRequest *reqObj = [NSURLRequest requestWithURL:url];
    [self.listWebView loadRequest:reqObj];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"web view load finished");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
