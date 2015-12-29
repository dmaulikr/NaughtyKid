/**
 *  Copyright 2014 Nest Labs Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#import "FirebaseManager.h"
#import "AccessToken.h"

#import <Firebase/Firebase.h>

@interface FirebaseManager ()

@property (nonatomic, strong) Firebase *rootFirebase;

+ (FirebaseManager *)sharedManager;

@property (nonatomic, strong) NSMutableDictionary* subscribedFirebases;
@property (nonatomic, strong) NSMutableDictionary* subscribedURLs;

@end

@implementation FirebaseManager

/**
 * Creates or retrieves the shared Firebase manager.
 * @return The singleton shared Firebase manager.
 */
+ (FirebaseManager *)sharedManager
{
    static dispatch_once_t once;
	static FirebaseManager *instance;
    
	dispatch_once(&once, ^{
		instance = [[FirebaseManager alloc] init];
	});
    
	return instance;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.subscribedFirebases = @{}.mutableCopy;
    self.subscribedURLs = @{}.mutableCopy;
    
    self.rootFirebase = [[Firebase alloc] initWithUrl:@"https://developer-api.nest.com/"];

    [self.rootFirebase authWithCredential:AccessToken.currentAccessToken.token
                      withCompletionBlock:nil
                          withCancelBlock:nil];
    
    return self;
}

+ (void)addSubscriptionToURL:(NSString *)URL withBlock:(SubscriptionBlock)block
{
    [self.sharedManager addSubscriptionToURL:URL withBlock:block];
}

/**
 * Adds a subscription to the URL and creates a new firebase for that subscription
 * @param URL The URL you wish to subscribe to.
 * @param block The block you want to execute when values change at the specified firebase location.
 */
- (void)addSubscriptionToURL:(NSString *)URL withBlock:(SubscriptionBlock)block
{
    if ([self.subscribedURLs objectForKey:URL]) {
        
        // Don't add another subscription
        block([self.subscribedURLs objectForKey:URL]);
        
    } else {
        Firebase *newFirebase = [self.rootFirebase childByAppendingPath:URL];

        [newFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            [self.subscribedURLs setObject:snapshot forKey:URL];
            block(snapshot);
        }];
        
        [self.subscribedFirebases setObject:newFirebase forKey:URL];

    }
}

@end
