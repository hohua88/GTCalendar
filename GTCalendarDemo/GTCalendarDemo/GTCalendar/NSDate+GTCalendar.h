//
//  NSDate+GTCalendar.h
//  GreenTravel
//
//  Created by eddy on 2017/11/9.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GTCalendar)

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(NSInteger)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(NSInteger)day;//获取当前日期之后的几个天

- (NSDateComponents *)YMDComponents;

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString

+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

@end
