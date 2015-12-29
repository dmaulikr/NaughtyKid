//
//  Camera.h
//  MonkeyBuiseness
//
//  Created by Vlad Soroka on 12/29/15.
//  Copyright © 2015 com.me.vlad. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CameraRecord : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString* name;

- (BOOL) isKidMisbehaving;

@end
