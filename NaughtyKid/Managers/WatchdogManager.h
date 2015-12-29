//
//  CameraManager.h
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CameraRecord.h"
#import "HomeRecord.h"

typedef void(^Callback)(CameraRecord* camera, HomeRecord* home);

@interface WatchdogManager : NSObject

+ (void) subscribeForWatchdogUpdatesWithBlock:(Callback)callback;

@end
