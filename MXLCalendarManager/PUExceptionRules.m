//
//  PUExceptionRules.m
//
//  Created by Maurice Arikoglu on 17.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

#import "PUExceptionRules.h"

@implementation PUExceptionRules

- (id)copyWithZone:(NSZone *)zone {

    PUExceptionRules *copy = [[PUExceptionRules allocWithZone:zone] init];
    
    if (copy) {
        
        [copy setExceptionRuleFrequency:[self.exceptionRuleFrequency copyWithZone:zone]];
        [copy setExceptionRuleCount:[self.exceptionRuleCount copyWithZone:zone]];
        [copy setExceptionRuleInterval:[self.exceptionRuleInterval copyWithZone:zone]];
        [copy setExceptionRuleWeekStart:[self.exceptionRuleWeekStart copyWithZone:zone]];

        [copy setExceptionRuleUntilDate:[self.exceptionRuleUntilDate copyWithZone:zone]];

        [copy setExceptionRulesBySecond:[self.exceptionRuleFrequency copyWithZone:zone]];
        [copy setExceptionRulesByMinute:[self.exceptionRulesByMinute copyWithZone:zone]];
        [copy setExceptionRulesByHour:[self.exceptionRulesByHour copyWithZone:zone]];
        [copy setExceptionRulesByDay:[self.exceptionRulesByDay copyWithZone:zone]];
        [copy setExceptionRulesByDayOfMonth:[self.exceptionRulesByDayOfMonth copyWithZone:zone]];
        [copy setExceptionRulesByDayOfYear:[self.exceptionRulesByDayOfYear copyWithZone:zone]];
        [copy setExceptionRulesByWeekOfYear:[self.exceptionRulesByWeekOfYear copyWithZone:zone]];
        [copy setExceptionRulesByMonth:[self.exceptionRulesByMonth copyWithZone:zone]];
        [copy setExceptionRulesBySetPosition:[self.exceptionRulesBySetPosition copyWithZone:zone]];

    }
    
    return copy;
}

@end
