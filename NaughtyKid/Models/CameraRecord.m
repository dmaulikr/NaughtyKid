//
//  Camera.m
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import "CameraRecord.h"

@interface CameraRecord ()

@property (nonatomic, strong) NSDate* eventEndDate;
@property (nonatomic, assign) BOOL isMotionDetected;

@end

@implementation CameraRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name_long",
             @"isMotionDetected" : @"last_event.has_motion",
             @"eventEndDate" : @"last_event.end_time"};
}

+ (NSDateFormatter*)dateFormatter {
    static NSDateFormatter* df = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    });
    return df;
}

+ (NSValueTransformer *)eventEndDateJSONTransformer {
    return
    [MTLValueTransformer transformerUsingForwardBlock:^id(NSString* value, BOOL *success, NSError *__autoreleasing *error) {
        NSDate* d = [self.dateFormatter dateFromString:value];
        return d;
    }];
}

- (BOOL)isKidMisbehaving
{
    BOOL isEventFinished = self.eventEndDate.timeIntervalSinceNow < 0;
    
    return !isEventFinished && self.isMotionDetected;
}

@end
