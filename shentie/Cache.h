//
//  Cache.h
//  shentie
//
//  Created by he yiyu on 13-12-3.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject
+ (void)setValue:(id)value withKey:(NSString *)key;
+ (id)getValueByKey:(NSString *)key;
+ (void)removeValueByKey:(NSString *)key;

+ (void)setValue:(id)value withKey:(NSString *)key andCat:(NSString *)cat;
+ (id)getValueByKey:(NSString *)key andCat:(NSString *)cat;
+ (void)removeValueByKey:(NSString *)key andCat:(NSString *)cat;
+ (void)removeAllValueByCat:(NSString *)cat;
@end
