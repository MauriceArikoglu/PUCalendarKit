//
//  MXLCalendarAttendee.m
//  ICSExporter
//
//  Created by Rahul Somasunderam on 6/20/14.
//  Copyright (c) 2014 MobileX Labs. All rights reserved.
//

#import "MXLCalendarAttendee.h"

@implementation MXLCalendarAttendee

- (id)copyWithZone:(NSZone *)zone {
    
    MXLCalendarAttendee *copy = [[MXLCalendarAttendee allocWithZone:zone] init];
    
    if (copy) {
        
        [copy setUri:[self.uri copyWithZone:zone]];
        [copy setCommonName:[self.commonName copyWithZone:zone]];
        
        [copy setRole:self.role];
    }
    
    return copy;
}

- (id)initWithRole:(PUAttendeeRole)role commonName:(NSString *)commonName andUri:(NSString *)uri {
    
    self = [super init];
    
    if (self) {
        
        self.role = role;
        self.commonName = commonName;
        self.uri = uri;
    }
    
    return self;
}

+ (instancetype)attendeeForString:(NSString *)attendeeString {
    
    if (attendeeString) {
        
        MXLCalendarAttendee *attendee = [[MXLCalendarAttendee alloc] init];
        
        if (attendee) {
            
            /* Example structure of Attendee:
             
             ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;CN=Halste
             d Street;X-NUM-GUESTS=0:mailto:ffc.com_j2r0bhi3cup4khh27r2d6koph4@group.cal
             endar.google.com
             
             */
            
            NSScanner *eventScanner = [NSScanner scannerWithString:attendeeString];
            NSString *uri, *attributes = @"";
            
            [eventScanner scanUpToString:@":" intoString:&attributes];
            [eventScanner scanUpToString:@"\n" intoString:&uri];
            
            //Assign the uri if length > 1
            attendee.uri = (uri.length > 1) ? [uri substringFromIndex:1] : nil;
            
            //Scan attributes
            NSScanner *attributesScanner = [NSScanner scannerWithString:attributes];
            NSString *placeholder = @"";
            
            [attributesScanner scanUpToString:@"ROLE=" intoString:nil];
            [attributesScanner scanUpToString:@";" intoString:&placeholder];
            
            NSString *role = [placeholder stringByReplacingOccurrencesOfString:@"ROLE=" withString:@""];
            NSValue *roleValue = [NSValue valueWithBytes:&role objCType:@encode(Role)];
            
            //Assign the Role
            attendee.role = (PUAttendeeRole)roleValue;
            
            attributesScanner = [NSScanner scannerWithString:attributes];
            [attributesScanner scanUpToString:@"CN=" intoString:nil];
            [attributesScanner scanUpToString:@";" intoString:&placeholder];
            
            NSString *name = [placeholder stringByReplacingOccurrencesOfString:@"CN=" withString:@""];
            attendee.commonName = name;
        }
        
        return attendee;
    } else {
        
        return nil;
    }
}


@end
