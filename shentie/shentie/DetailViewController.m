//
//  DetailViewController.m
//  shentie
//
//  Created by he yiyu on 13-12-2.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import "DetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface DetailViewController ()
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *id;
@end

@implementation DetailViewController
@synthesize detailWebView = _detailWebView;
@synthesize detailContainerView = _detailContainerView;
@synthesize url = _url;
@synthesize id = _id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setUrl:(NSString *)url andId:(NSNumber *)id {
    self.url = url;
    self.id = id;
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
        NSLog(@"%f, %f, %f", self.detailWebView.frame.origin.y ,self.detailWebView.frame.size.height,
              SCREEN_HEIGHT);
        self.detailWebView.frame = CGRectMake(0,
                                              self.detailWebView.frame.origin.y - 20,
                                              self.detailWebView.frame.size.width,
                                              self.detailWebView.frame.size.height + 20);
        NSLog(@"%f, %f, %f", self.detailWebView.frame.origin.y ,self.detailWebView.frame.size.height,
              SCREEN_HEIGHT);
    }
    UIColor *controllerContainerColour = [UIColor colorWithRed:0 green:219 / 255.0 blue: 222 / 255.0 alpha:1.00f];
    self.controllerContainerView.backgroundColor = controllerContainerColour;
}

- (void)initControllerBar {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //must have url and id
    if (!self.url || !self.id) {
        return;
    }
    [self setupStyle];
    self.detailWebView.scalesPageToFit = YES;
    self.detailWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *reqObj = [NSURLRequest requestWithURL:url];
    [self.detailWebView loadRequest:reqObj];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
