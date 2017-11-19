//
//  NSString+PUCalendarICSEnumerations.m
//  ICSExporter
//
//  Created by Maurice Arikoglu on 19.11.17.
//  Copyright © 2017 MobileX Labs. All rights reserved.
//

#import "NSString+PUCalendarICSEnumerations.h"

@implementation NSString (PUCalendarICSEnumerations)

- (PUStatus)statusForICSStatusString {
    
    /*
     ICS status strings as found here https://www.kanzaki.com/docs/ical/status.html
     */
    NSDictionary<NSString*,NSNumber*> *status = @{
                                                  @"TENTATIVE" : @(PUStatusTentative),
                                                  @"CONFIRMED" : @(PUStatusConfirmed),
                                                  @"CANCELLED" : @(PUStatusCancelled)
                                                  };
    
    return status[self].integerValue;
}

- (PUFrequency)frequencyForICSFrequencyString {
    
    /*
     ICS frequency strings as found here https://www.kanzaki.com/docs/ical/recur.html
     */
    NSDictionary<NSString*,NSNumber*> *frequencies = @{
                                                       @"SECONDLY" : @(PUFrequencySecondly),
                                                       @"MINUTELY" : @(PUFrequencyMinutely),
                                                       @"HOURLY"   : @(PUFrequencyHourly),
                                                       @"DAILY"    : @(PUFrequencyDaily),
                                                       @"WEEKLY"   : @(PUFrequencyWeekly),
                                                       @"MONTHLY"  : @(PUFrequencyMonthly),
                                                       @"YEARLY"   : @(PUFrequencyYearly),
                                                       };
    
    return frequencies[self].integerValue;
}

- (PURole)roleForICSRoleString {

    /*
     ICS Role strings as found here https://www.kanzaki.com/docs/ical/role.html
     */
    NSDictionary<NSString*,NSNumber*> *roles = @{
                                                 @"CHAIR"           : @(PURoleChair),
                                                 @"REQ-PARTICIPANT" : @(PURoleRequiredParticipant),
                                                 @"OPT-PARTICIPANT" : @(PURoleOptionalParticipant),
                                                 @"NON-PARTICIPANT" : @(PURoleNonParticipant),
                                                 @"x-name"          : @(PURoleX_NAME),
                                                 @"iana-token"      : @(PURoleIANA_TOKEN),
                                                 };
    
    return roles[self].integerValue;
}

@end
