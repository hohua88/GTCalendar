//
//  GTCalendarLogic.m
//  GreenTravel
//
//  Created by eddy on 2017/11/13.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "GTCalendarLogic.h"
#import "GTCalendarDayModel.h"
#import "NSDate+GTCalendar.h"

@interface GTCalendarLogic ()
{
    NSDate *today;//今天的日期
    NSDate *select;//选择的日期
    GTCalendarDayModel *selectCalendarDay;
}
@end
@implementation GTCalendarLogic

//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)selectdate needMonths:(NSInteger)months_number
{
    //如果为空就从当天的日期开始
    if(date == nil){
        date = [NSDate date];
    }
    
    //默认选择中的时间
    if (selectdate == nil) {
        selectdate = date;
    }
    
    today = date;//起始日期
    
    select = selectdate;//选择的日期
    
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    
    for (int i = 0; i <months_number; i++) {
        
        NSDate *month = [today dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];//计算上月份在这个月的天数
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];//计算本月的天数
        [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份在这个月的天数
        
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    
    return calendarMonth;
    
}



#pragma mark - 日历上+当前+下月份的天数

//计算上月份在本月的天数

- (void)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
    
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    NSUInteger partialDaysCount = weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取年月日对象
    
    for (NSUInteger i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        
        GTCalendarDayModel *calendarDay = [GTCalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CalendarCellDayTypeEmpty;//不显示
        [array addObject:calendarDay];
    }
}

//计算下月份在本月的天数

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        GTCalendarDayModel *calendarDay = [GTCalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CalendarCellDayTypeEmpty;
        [array addObject:calendarDay];
    }
}


//计算当月的天数

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array {
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        GTCalendarDayModel *calendarDay = [GTCalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        
        [self changStyle:calendarDay];
        [array addObject:calendarDay];
    }
}

- (void)changStyle:(GTCalendarDayModel *)calendarDay
{
    NSDateComponents *calendarToDay  = [today YMDComponents];//今天
    NSDateComponents *calendarSelect = [select YMDComponents];//默认选择的那一天
    
    //被点击选中
    if(calendarSelect.year == calendarDay.year &
       calendarSelect.month == calendarDay.month &
       calendarSelect.day == calendarDay.day){
        
        calendarDay.style = CalendarCellDayTypeClick;
        selectCalendarDay = calendarDay;
    }else{
        //昨天乃至过去的时间设置一个灰度
        if (calendarToDay.year >= calendarDay.year &
            calendarToDay.month >= calendarDay.month &
            calendarToDay.day > calendarDay.day) {
            
            calendarDay.style = CalendarCellDayTypePast;
            //之后的时间时间段
        }else{
            calendarDay.style = CalendarCellDayTypeFuture;
        }
    }
    //今天
    if (calendarToDay.year == calendarDay.year &&
        calendarToDay.month == calendarDay.month &&
        calendarToDay.day == calendarDay.day) {
        calendarDay.holiday = @"今天";
        
        //明天
    }else if(calendarToDay.year == calendarDay.year &&
             calendarToDay.month == calendarDay.month &&
             calendarToDay.day - calendarDay.day == -1){
        calendarDay.holiday = @"明天";
        
    }
}

@end
