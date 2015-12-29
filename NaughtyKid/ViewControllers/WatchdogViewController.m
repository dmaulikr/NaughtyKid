//
//  MonkeyViewController.m
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import "WatchdogViewController.h"

#import "WatchdogManager.h"

@interface WatchdogViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation WatchdogViewController

+ (instancetype)controller
{
    UIStoryboard* s = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WatchdogViewController* controller = [s instantiateViewControllerWithIdentifier:@"WatchdogViewController"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WatchdogManager subscribeForWatchdogUpdatesWithBlock:^(CameraRecord* camera, HomeRecord* home){
        
        self.spinner.hidden = YES;
        
        if(home.awayStatus == AwayStatusHome)
        {
            self.statusLabel.text = @"You're at home. Good. We won't bother you until you go out.";
        }
        else if (camera.isKidMisbehaving)
        {
            self.statusLabel.text = @"Oh no! Kid has just left his room!";
            [self sendLocalNotification];
        }
        else
        {
            self.statusLabel.text = @"Kid is in room. All is good now";
        }
    }];
}

- (void) sendLocalNotification
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Oh no! Kid has just left his room!";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
