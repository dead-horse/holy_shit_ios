//
//  PostsRequest.h
//  shentie
//
//  Created by he yiyu on 13-12-3.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PostRequestDelegate;

@interface PostsRequest : NSObject

@property(weak) id<PostRequestDelegate> delegate;
- (void)getPostById:(NSNumber *)postId;
- (void)postGoodById:(NSNumber *)postId;
@end

@protocol PostRequestDelegate <NSObject>

@optional
-(void) getPostByIdCallback:(NSDictionary *)result error:(NSError *)err;
-(void) postGoodByIdCallback:(NSDictionary *)result error:(NSError *)err;

@end
