//
//  RequestSubuserList.m
//  akucun
//
//  Created by Jarry Z on 2018/4/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestSubuserList.h"

@implementation RequestSubuserList

- (HttpResponseBase *) response
{
    return [ResponseSubuserList new];
}

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"subuserinfobyuserid";
}

@end
