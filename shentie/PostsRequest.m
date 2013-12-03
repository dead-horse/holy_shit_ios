//
//  PostsRequest.m
//  shentie
//
//  Created by he yiyu on 13-12-3.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import "PostsRequest.h"
#import <AFNetworking.h>

@interface PostsRequest()
@property (nonatomic, strong) AFHTTPRequestOperationManager * manager;
@end

@implementation PostsRequest
@synthesize manager = _manager;
-(AFHTTPRequestOperationManager *) manager {
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc]
                    initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return _manager;
}

- (void)getPostById:(NSNumber *)postId {
    NSString *path = [NSString stringWithFormat:@"/api/posts/%@", postId];

    [self.manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate getPostByIdCallback:responseObject error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate getPostByIdCallback:nil error:error];
    }];
}

- (void)postGoodById:(NSNumber *)postId {
    NSString *path = [NSString stringWithFormat:@"/api/posts/%@/good", postId];
    [self.manager PATCH:path parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate postGoodByIdCallback:responseObject error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate postGoodByIdCallback:nil error:error];
    }];
}

- (void)postViewById:(NSNumber *)postId {
    NSString *path = [NSString stringWithFormat:@"/api/posts/%@/view", postId];
    [self.manager PATCH:path parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate postViewByIdCallback:responseObject error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate postViewByIdCallback:nil error:error];
    }];
}

@end
