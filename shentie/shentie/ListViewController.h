//
//  ListViewController.h
//  shentie
//
//  Created by he yiyu on 13-12-1.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BridageCallback)(id responseData);

@interface ListViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *listContainerView;
@property (weak, nonatomic) IBOutlet UIWebView *listWebView;

@end
