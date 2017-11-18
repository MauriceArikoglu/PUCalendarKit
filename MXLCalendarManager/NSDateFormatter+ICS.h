//
//  NSDateFormatter+ICS.h
//  ICSExporter
//
//  Created by Maurice Arikoglu on 17.11.17.
//  Copyright © 2017 MobileX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (ICS)

@property (nonatomic, assign) BOOL containsTime;
@property (nonatomic, assign) BOOL containsZone;

+ (instancetype)dateFormatterForICSDateString:(NSString *)dateString;

@end
