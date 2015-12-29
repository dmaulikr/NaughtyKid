//
//  Home.m
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import "HomeRecord.h"

@implementation HomeRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name",
             @"awayStatus" : @"away"};
}

+ (NSValueTransformer *)awayStatusJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"away": @(AwayStatusAway),
                                                                           @"home": @(AwayStatusHome),
                                                                           @"auto_away":@(AwayStatusAutoAway)
                                                                           }];
}

@end
