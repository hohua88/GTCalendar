//
//  GTCalendarDayModel.h
//  GreenTravel
//
//  Created by eddy on 2017/11/13.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CalendarCellDayType) {
    CalendarCellDayTypeEmpty,   //不显示
    CalendarCellDayTypePast,    //过去的日期
    CalendarCellDayTypeFuture,   //将来的日期
    CalendarCellDayTypeClick
};

@interface GTCalendarDayModel : NSObject

@property (nonatomic, assign) CalendarCellDayType style;

@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年

@property (nonatomic, strong) NSString *holiday;//节日

+ (GTCalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@end
