//
//  PUEventAttendee.h
//
//  Created by Maurice Arikoglu, based on MXLCalendarManager Framework by Kiran Panesar created on 09/04/2013.
//  Copyright (c) 2017 Maurice Arikoglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCalendarEnumerations.h"

@interface PUEventAttendee : NSObject <NSCopying>

@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *commonName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) PURole role;

- (id)initWithRole:(PURole)role commonName:(NSString *)commonName email:(NSString *)email status:(NSString*)status andUri:(NSString *)uri;
+ (instancetype)attendeeForString:(NSString *)attendeeString;

@end
