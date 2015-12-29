//
//  RootViewController.m
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import "RootNavigationController.h"

#import "AccessToken.h"

#import "AuthorizationViewController.h"
#import "WatchdogViewController.h"

@interface RootNavigationController () <Vprotocol>

@end

@implementation RootNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIViewController* rootViewController = nil;
    if(AccessToken.currentAccessToken.isValid) {
        rootViewController = WatchdogViewController.controller;
    }
    else {
        rootViewController = [AuthorizationViewController controllerWithDelegate:self];
    }
    
    self.viewControllers = @[rootViewController];
}

- (void)userDidLogin
{
    [self setViewControllers:@[WatchdogViewController.controller] animated:YES];
}

@end
