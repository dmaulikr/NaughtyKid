//
//  Home.h
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, AwayStatus)
{
    AwayStatusAway,
    AwayStatusHome,
    
    AwayStatusAutoAway,
};



@interface HomeRecord : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, assign, readonly) AwayStatus awayStatus;

@end