//
//  PUExceptionRules.h
//
//  Created by Maurice Arikoglu on 17.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCalendarEnumerations.h"

@interface PUExceptionRules : NSObject <NSCopying>

@property (nonatomic, assign) PUFrequency exceptionRuleFrequency;
@property (nonatomic, copy) NSString *exceptionRuleCount;

@property (nonatomic, copy) NSString *exceptionRuleInterval;
@property (nonatomic, copy) NSString *exceptionRuleWeekStart;

@property (nonatomic, copy) NSDate   *exceptionRuleUntilDate;

@property (nonatomic, retain) NSArray *exceptionRulesBySecond;
@property (nonatomic, retain) NSArray *exceptionRulesByMinute;
@property (nonatomic, retain) NSArray *exceptionRulesByHour;
@property (nonatomic, retain) NSArray *exceptionRulesByDay;
@property (nonatomic, retain) NSArray *exceptionRulesByDayOfMonth;
@property (nonatomic, retain) NSArray *exceptionRulesByDayOfYear;
@property (nonatomic, retain) NSArray *exceptionRulesByWeekOfYear;
@property (nonatomic, retain) NSArray *exceptionRulesByMonth;
@property (nonatomic, retain) NSArray *exceptionRulesBySetPosition;

@end
