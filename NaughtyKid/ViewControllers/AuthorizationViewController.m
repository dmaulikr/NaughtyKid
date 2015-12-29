//
//  ViewController.m
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import "AuthorizationViewController.h"

#import "AccessToken.h"
#import "NestWebViewAuthController.h"

#import <AFNetworking/AFHTTPSessionManager.h>
#import "Constants.h"

@interface AuthorizationViewController () <NestWebViewAuthControllerDelegate>

@property (nonatomic, strong) AFHTTPSessionManager* manager;
@property (nonatomic, weak) id<AuthorizationProtocol> delegate;

@end

@implementation AuthorizationViewController

+ (instancetype)controllerWithDelegate:(id<AuthorizationProtocol>)delegate
{
    UIStoryboard* s = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AuthorizationViewController* controller = [s instantiateViewControllerWithIdentifier:@"AuthorizationViewController"];
    controller.delegate = delegate;
    return controller;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self) return nil;
    
    NSString* baseURLString = [NSString stringWithFormat:@"https://api.%@/oauth2", NestCurrentAPIDomain];
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    
    return self;
}

- (IBAction)login:(id)sender {
    
    NestWebViewAuthController* controller = [NestWebViewAuthController controllerWithDelegate:self];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)foundAuthorizationCode:(NSString *)authorizationCode
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    __weak typeof(self) wSelf = self;
    [self.manager POST:@"access_token"
            parameters:@{@"code" : authorizationCode,
                         @"client_id" : NestClientID,
                         @"client_secret" : NestClientSecret,
                         @"grant_type" : @"authorization_code"}
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task,
                         NSDictionary*  _Nullable responseObject) {
                   
                   long expiresIn = [responseObject[@"expires_in"] longValue];
                   NSString *accessToken = responseObject[@"access_token"];
                   
                   [AccessToken tokenWithToken:accessToken
                                     expiresIn:expiresIn];
                   
                   [wSelf.delegate userDidLogin];
               }
               failure:nil];
}

- (IBAction)notificationSwitchChanged:(id)sender {
    UIUserNotificationType types =
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

@end
