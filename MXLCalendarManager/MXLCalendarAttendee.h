//
//  MXLCalendarAttendee.h
//  ICSExporter
//
//  Created by Rahul Somasunderam on 6/20/14.
//  Copyright (c) 2014 MobileX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PUAttendeeRole) {
    
    PUAttendeeRoleChair,
    PUAttendeeRoleRequiredParticipant,
    PUAttendeeRoleOptionalParticipant,
    PUAttendeeRoleNonParticipant
    
};

typedef enum {
    
    CHAIR,
    REQ_PARTICIPANT,
    OPT_PARTICIPANT,
    NON_PARTICIPANT
    
} Role;

//@protocol MXLCalendarAttendee
//
//@end
@interface MXLCalendarAttendee : NSObject <NSCopying>

@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *commonName;
@property (nonatomic, assign) PUAttendeeRole role;

- (id)initWithRole:(PUAttendeeRole)role commonName:(NSString *)commonName andUri:(NSString *)uri;
+ (instancetype)attendeeForString:(NSString *)attendeeString;

@end
