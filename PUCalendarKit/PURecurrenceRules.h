//
//  PURecurrenceRules.h
//
//  Created by Maurice Arikoglu on 17.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCalendarEnumerations.h"

@interface PURecurrenceRules : NSObject <NSCopying>

@property (nonatomic, assign) PUFrequency repeatRuleFrequency;

@property (nonatomic, assign) NSInteger repeatRuleCount;
@property (nonatomic, assign) NSInteger repeatRuleInterval;

@property (nonatomic, copy) NSString *repeatRuleWeekStart;

@property (nonatomic, copy) NSDate *repeatRuleUntilDate;

@property (nonatomic, retain) NSArray <NSString *>*repeatRulesBySecond;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesByMinute;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesByHour;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesByDay;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesByDayOfMonth;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesByDayOfYear;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesByWeekOfYear;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesByMonth;
@property (nonatomic, retain) NSArray <NSString *>*repeatRulesBySetPosition;

@end
