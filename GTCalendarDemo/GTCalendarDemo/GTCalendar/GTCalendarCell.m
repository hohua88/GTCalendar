//
//  GTCalendarCell.m
//  GreenTravel
//
//  Created by eddy on 2017/11/13.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "GTCalendarCell.h"
#import "GTCalendarDayModel.h"

@interface GTCalendarCell ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation GTCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.selectedImageView];
        [self.contentView addSubview:self.dayLabel];
        [self.contentView addSubview:self.priceLabel];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [_selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_dayLabel.mas_bottom).offset(2);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //添加分割线
    UIView *horLineView = [[UIView alloc] init];
    horLineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:horLineView];
    [horLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.bottom.and.trailing.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    UIView *verLineView = [[UIView alloc] init];
    verLineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:verLineView];
    [verLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.trailing.equalTo(@0);
        make.width.equalTo(@0.5);
    }];
}

#pragma mark - getter

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [UIImageView new];
        _selectedImageView.image = [UIImage imageNamed:@"check"];
    }
    return _selectedImageView;
}
- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dayLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = [UIColor lightGrayColor];
        _priceLabel.font = [UIFont systemFontOfSize:12];
    }
    return _priceLabel;
}

- (void)setCanSelect:(BOOL)canSelect {
    _dayLabel.textColor = canSelect?[UIColor blackColor]:[UIColor lightGrayColor];
    
}

#pragma mark - setter

- (void)setModel:(GTCalendarDayModel *)model {
    switch (model.style) {
        case CalendarCellDayTypeEmpty://不显示
            _selectedImageView.hidden = YES;
            _dayLabel.hidden = YES;
            _priceLabel.hidden = YES;
            break;
        case CalendarCellDayTypePast://过去的日期
            _dayLabel.hidden = NO;
            _priceLabel.hidden = NO;
            _dayLabel.text = [NSString stringWithFormat:@"%ld",model.day];
            
            _dayLabel.textColor = [UIColor lightGrayColor];
            
            _selectedImageView.hidden = YES;
            break;
            
        case CalendarCellDayTypeFuture://将来的日期
            _dayLabel.hidden = NO;
            _priceLabel.hidden = NO;
            if (model.holiday) {
                _dayLabel.text = model.holiday;
                
                _dayLabel.textColor = [UIColor blackColor];
            }else{
                _dayLabel.text = [NSString stringWithFormat:@"%ld",model.day];
                
                _dayLabel.textColor = [UIColor blackColor];
            }
            
            _selectedImageView.hidden = YES;
            break;
            
        case CalendarCellDayTypeClick://被点击的日期
            if (model.holiday) {
                _dayLabel.text = model.holiday;
                
                _dayLabel.textColor = [UIColor blackColor];
            }else{
                _dayLabel.text = [NSString stringWithFormat:@"%ld",model.day];
                
                _dayLabel.textColor = [UIColor blackColor];
            }
            _dayLabel.textColor = [UIColor whiteColor];
            _dayLabel.hidden = NO;
            _priceLabel.hidden = NO;
            _selectedImageView.hidden = NO;
            
            break;
    }
}
@end
