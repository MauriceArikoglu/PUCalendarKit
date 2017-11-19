//
//  PUCalendarEnumerations.h
//  ICSExporter
//
//  Created by Maurice Arikoglu on 19.11.17.
//  Copyright © 2017 MobileX Labs. All rights reserved.
//

#ifndef PUCalendarEnumerations_h
#define PUCalendarEnumerations_h

typedef NS_ENUM(NSInteger, PURole) {
    
    PURoleChair,
    PURoleRequiredParticipant,
    PURoleOptionalParticipant,
    PURoleNonParticipant,
    PURoleX_NAME,
    PURoleIANA_TOKEN
    
};

typedef NS_ENUM(NSInteger, PUFrequency) {
    
    PUFrequencySecondly,
    PUFrequencyMinutely,
    PUFrequencyHourly,
    PUFrequencyDaily,
    PUFrequencyWeekly,
    PUFrequencyMonthly,
    PUFrequencyYearly
    
};
/*
typedef NS_ENUM(NSInteger, PUShortWeekday) {
    //Gregorian Calendar 1-7
    PUShortWeekdayUNDEFINED,
    PUShortWeekdaySunday,
    PUShortWeekdayMonday,
    PUShortWeekdayTuesday,
    PUShortWeekdayWednesday,
    PUShortWeekdayThursday,
    PUShortWeekdayFriday,
    PUShortWeekdaySaturday
    
};
*/

#endif /* PUCalendarEnumerations_h */
