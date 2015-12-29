//
//  ViewController.h
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Vprotocol <NSObject>

- (void) userDidLogin;

@end

@interface AuthorizationViewController : UIViewController

+ (instancetype) controllerWithDelegate:(id<Vprotocol>)delegate;

@end

