//
//  GTCalendarLogic.h
//  GreenTravel
//
//  Created by eddy on 2017/11/13.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCalendarLogic : NSObject

- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)date1 needMonths:(NSInteger)months_number;

@end
