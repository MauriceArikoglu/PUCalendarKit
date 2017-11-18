//
//  PURecurrenceRules.h
//
//  Created by Maurice Arikoglu on 17.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PURecurrenceRules : NSObject <NSCopying>

@property (nonatomic, copy) NSString *repeatRuleFrequency;
@property (nonatomic, copy) NSString *repeatRuleCount;

@property (nonatomic, copy) NSString *repeatRuleInterval;
@property (nonatomic, copy) NSString *repeatRuleWeekStart;

@property (nonatomic, copy) NSDate *repeatRuleUntilDate;

@property (nonatomic, retain) NSArray *repeatRulesBySecond;
@property (nonatomic, retain) NSArray *repeatRulesByMinute;
@property (nonatomic, retain) NSArray *repeatRulesByHour;
@property (nonatomic, retain) NSArray *repeatRulesByDay;
@property (nonatomic, retain) NSArray *repeatRulesByDayOfMonth;
@property (nonatomic, retain) NSArray *repeatRulesByDayOfYear;
@property (nonatomic, retain) NSArray *repeatRulesByWeekOfYear;
@property (nonatomic, retain) NSArray *repeatRulesByMonth;
@property (nonatomic, retain) NSArray *repeatRulesBySetPosition;

@end
