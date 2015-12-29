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

#import "AccessToken.h"

NSString * const kAccessTokenKey = @"accessToken";

@interface AccessToken () <NSCoding>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDate *expiresOn;

@end

@implementation AccessToken

+ (instancetype)currentAccessToken
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenKey];
    AccessToken *at = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return at;
}

/**
 * Tells whether or not the token is valid.
 * @return YES if valid token. NO if invalid token.
 */
- (BOOL)isValid
{
    return [NSDate.date compare:self.expiresOn] == NSOrderedAscending;
}

/**
 * Sets the token and expiration date.
 * @param token The token string.
 * @param expiration The amount of time (in seconds) the token has until it expires.
 */
+ (AccessToken *)tokenWithToken:(NSString *)token expiresIn:(long)expiration;
{
    AccessToken *accessToken = [[AccessToken alloc] init];
    accessToken.token = token;
    accessToken.expiresOn = [[NSDate date] dateByAddingTimeInterval:expiration];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return accessToken;
}

/**
 * Encode the access token.
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.expiresOn forKey:@"expiresOn"];
}

/**
 * Decode the access token.
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.token = [decoder decodeObjectForKey:@"token"];
        self.expiresOn = [decoder decodeObjectForKey:@"expiresOn"];
    }
    return self;
}

@end
