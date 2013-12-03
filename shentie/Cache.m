//
//  Cache.m
//  shentie
//
//  Created by he yiyu on 13-12-3.
//  Copyright (c) 2013年 wanshanglaiwojiachifan. All rights reserved.
//

#import "Cache.h"

@interface Cache()
+ (NSString *)genTokenWithKey:(NSString *) key andCat:(NSString *)cat;
@end

@implementation Cache

+ (void)setValue:(id)value withKey:(NSString *)key {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
    [ud synchronize];
}

+ (id)getValueByKey:(NSString *)key {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

+ (void)removeValueByKey:(NSString *)key {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    [ud synchronize];
}

+ (NSString *)genTokenWithKey:(NSString *) key andCat:(NSString *)cat {
    return [NSString stringWithFormat:@"%@:%@", cat, key];
}

+ (void)setValue:(id)value withKey:(NSString *)key andCat:(NSString *)cat {
    NSString *token = [Cache genTokenWithKey:key andCat:cat];
    
    //set all cat key into ud, so you can delete it by catname
    NSString *catKey = [NSString stringWithFormat:@"keysofcat:%@", cat];
    id catkeys = [Cache getValueByKey:catKey];
    NSDictionary *catkeyObj = nil;
    
    if (!catkeys) {
        catkeyObj = @{token: @1};
    } else {
        NSMutableDictionary *mcatkeyObj = [catkeys mutableCopy];
        mcatkeyObj[token] = @1;
    }
    [Cache setValue:catKey withKey:catkeyObj];
    
    [Cache setValue:value withKey:token];
}

+ (id)getValueByKey:(NSString *)key andCat:(NSString *)cat {
    NSString *token = [Cache genTokenWithKey:key andCat:cat];
    return [Cache getValueByKey:token];
}

+ (void)removeValueByKey:(NSString *)key andCat:(NSString *)cat {
    NSString *token = [Cache genTokenWithKey:key andCat:cat];
    NSString *catKey = [NSString stringWithFormat:@"keysofcat:%@", cat];
    
    //update cat obj in ud
    NSMutableDictionary *catkeyObj = [[Cache getValueByKey:catKey] mutableCopy];
    [catkeyObj removeObjectForKey:token];
    [Cache setValue:[catkeyObj copy] withKey:catKey];
    
    [Cache removeValueByKey:token];
}

+ (void)removeAllValueByCat:(NSString *)cat {
    NSString *catKey = [NSString stringWithFormat:@"keysofcat:%@", cat];
    
    //get all cat keys, and remove it from ud
    NSDictionary *catkeyObj = [Cache getValueByKey:catKey];
    for (NSString *token in [catkeyObj allValues]) {
        [Cache removeValueByKey:token];
    }
    
    [Cache removeValueByKey:catKey];
}
@end
