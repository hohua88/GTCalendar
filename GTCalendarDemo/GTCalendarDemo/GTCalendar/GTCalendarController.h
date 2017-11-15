//
//  GTCalendarController.h
//  GreenTravel
//
//  Created by eddy on 2017/11/9.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTCalendarDayModel.h"

typedef void(^DatePickBlock)(GTCalendarDayModel *model);

@interface GTCalendarController : UIViewController

@property (nonatomic, copy)DatePickBlock callBlock;

- (instancetype)initWithMonthNumber:(NSUInteger)months selected:(NSString *)selectedDate;

@end
