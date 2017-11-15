//
//  GTCalendarDayModel.m
//  GreenTravel
//
//  Created by eddy on 2017/11/13.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "GTCalendarDayModel.h"

@implementation GTCalendarDayModel
+ (GTCalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    GTCalendarDayModel *calendarDay = [[GTCalendarDayModel alloc] init];//初始化自身
    calendarDay.year = year;//年
    calendarDay.month = month;//月
    calendarDay.day = day;//日
    
    return calendarDay;
}
@end
