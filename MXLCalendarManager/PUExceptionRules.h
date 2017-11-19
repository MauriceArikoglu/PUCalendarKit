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

@property (nonatomic, assign) NSInteger exceptionRuleCount;
@property (nonatomic, assign) NSInteger exceptionRuleInterval;

@property (nonatomic, copy) NSString *exceptionRuleWeekStart;

@property (nonatomic, copy) NSDate *exceptionRuleUntilDate;

@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesBySecond;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesByMinute;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesByHour;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesByDay;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesByDayOfMonth;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesByDayOfYear;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesByWeekOfYear;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesByMonth;
@property (nonatomic, retain) NSArray <NSString *>*exceptionRulesBySetPosition;

@end
