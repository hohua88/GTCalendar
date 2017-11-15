//
//  GTCalendarHeaderView.m
//  GreenTravel
//
//  Created by eddy on 2017/11/13.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "GTCalendarHeaderView.h"

@implementation GTCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.yearLabel];
        [self addSubview:self.partLine];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_partLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yearLabel.mas_bottom).offset(0.5);
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}
#pragma mark - getter
- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [UILabel new];
        _yearLabel.textColor = [UIColor blackColor];
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        _yearLabel.font = [UIFont systemFontOfSize:16];
    }
    return _yearLabel;
}

- (UILabel *)partLine {
    if (!_partLine) {
        _partLine = [UILabel new];
        _partLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _partLine;
}

@end
