//
//  CameraManager.m
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import "WatchdogManager.h"

#import "FirebaseManager.h"

@interface WatchdogManager()

@property (nonatomic, strong) Callback callback;

@property (nonatomic, strong) CameraRecord* lastCameraRecord;
@property (nonatomic, strong) HomeRecord* lastHomeRecord;

@end

@implementation WatchdogManager

+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    static WatchdogManager *instance;
    
    dispatch_once(&once, ^{
        instance = [[WatchdogManager alloc] init];
    });
    
    return instance;
}

+ (void)subscribeForWatchdogUpdatesWithBlock:(Callback)callback
{
    WatchdogManager* manager = WatchdogManager.sharedManager;
    manager.callback = callback;
    
    [FirebaseManager addSubscriptionToURL:@"structures/" withBlock:^(FDataSnapshot *snapshot) {
        NSString* homeId = [[snapshot.value allKeys] firstObject];
        [manager subscribeForUpdatesWithHomeId:homeId];
        
        NSString* cameraId = [[[[snapshot.value allObjects] firstObject] valueForKey:@"cameras"] firstObject];
        [manager subscribeForUpdatesWithCameraId:cameraId];
    }];
}

- (void) subscribeForUpdatesWithHomeId:(NSString*)homeId
{
    NSString* subscriptionPath = [NSString stringWithFormat:@"structures/%@/", homeId];
    
    [FirebaseManager addSubscriptionToURL:subscriptionPath
                                withBlock:^(FDataSnapshot *snapshot) {
                                    self.lastHomeRecord = [MTLJSONAdapter modelOfClass:HomeRecord.class
                                                                    fromJSONDictionary:snapshot.value
                                                                                 error:nil];
                                    
                                    self.callback(self.lastCameraRecord, self.lastHomeRecord);
                                }];
}

- (void) subscribeForUpdatesWithCameraId:(NSString*)cameraId
{
    NSString* subscriptionPath = [NSString stringWithFormat:@"devices/cameras/%@/", cameraId];
    
    [FirebaseManager addSubscriptionToURL:subscriptionPath
                                withBlock:^(FDataSnapshot *snapshot) {
                                    
                                    self.lastCameraRecord = [MTLJSONAdapter modelOfClass:CameraRecord.class
                                                                      fromJSONDictionary:snapshot.value
                                                                                   error:nil];

                                    self.callback(self.lastCameraRecord, self.lastHomeRecord);
                                    
                                }];
}

@end
