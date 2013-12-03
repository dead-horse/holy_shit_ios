//
//  DetailViewController.h
//  shentie
//
//  Created by he yiyu on 13-12-2.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsRequest.h"

@interface DetailViewController : UIViewController <UIWebViewDelegate, PostRequestDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailContainerView;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UIView *controllerContainerView;

- (void) setupData: (NSDictionary *)data;

//post request delegate
- (void)postGoodByIdCallback:(NSDictionary *)result error:(NSError *)err;
@end
