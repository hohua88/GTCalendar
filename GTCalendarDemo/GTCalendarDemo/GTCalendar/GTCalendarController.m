//
//  GTCalendarController.m
//  GreenTravel
//
//  Created by eddy on 2017/11/9.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "GTCalendarController.h"
#import "GTCalendarCell.h"
#import "GTCalendarHeaderView.h"
#import "GTCalendarLogic.h"
#import "NSDate+GTCalendar.h"

#define week_days @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]
@interface GTCalendarController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *dateCollectionView;//日历控件

@property (nonatomic, strong) UIButton *cancelButton;//取消按钮

@property (nonatomic, strong) UILabel *titleLable;//标题

@property (nonatomic, strong) UIView *weekView; //周一到周末

@property (nonatomic, strong) UILabel *partLineLabel; //分割线

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) GTCalendarLogic *logic; //日历处理逻辑

@property (nonatomic, strong) NSMutableArray *calendarMonths;//需要展示月信息

@property (nonatomic, strong) UIView *bgView;//背景

@property (nonatomic, assign) NSUInteger months;//需要展示月个数

@property (nonatomic, strong) NSString *selectedDate;//选中日期
 
@end

@implementation GTCalendarController

- (instancetype)initWithMonthNumber:(NSUInteger)months selected:(NSString *)selectedDate {
    self = [super init];
    if (self) {
        _months = months;
        _selectedDate = selectedDate;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.dateCollectionView];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.weekView];
    [self.view addSubview:self.partLineLabel];
    
    _calendar = [NSCalendar currentCalendar];
    
    _calendarMonths = [self getMonthArrayOfMonthNumber:_months selectDateforString:_selectedDate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GTCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GTCalendarCell class]) forIndexPath:indexPath];
    NSMutableArray *monthArray = [_calendarMonths objectAtIndex:indexPath.section];
    
    GTCalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSMutableArray *monthArray = [_calendarMonths objectAtIndex:section];
    
    return monthArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _calendarMonths.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    GTCalendarHeaderView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([GTCalendarHeaderView class]) forIndexPath:indexPath];
    NSMutableArray *month_Array = [_calendarMonths objectAtIndex:indexPath.section];
    GTCalendarDayModel *model = [month_Array objectAtIndex:15];
    head.yearLabel.text = [NSString stringWithFormat:@"%ld年 %ld月",model.year,model.month];
    return head;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *month_Array = [_calendarMonths objectAtIndex:indexPath.section];
    GTCalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    if (model.style == CalendarCellDayTypeFuture ||model.style == CalendarCellDayTypeClick) {
        NSLog(@"model === %@", model);
        _callBlock(model);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

#pragma mark - private
- (void)removeSelf:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfMonthNumber:(NSUInteger)month selectDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        selectdate = [selectdate dateFromString:todate];
    }
    
    _logic = [[GTCalendarLogic alloc]init];
    
    return [_logic reloadCalendarView:date selectDate:selectdate  needMonths:month];
}
#pragma mark - getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UICollectionView *)dateCollectionView {
    if (!_dateCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemW = (kScreenWidth - 3) / 7;
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 30);
        flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 10);
        flowLayout.minimumLineSpacing = 0.5;
        flowLayout.minimumInteritemSpacing = 0.5;
        
        _dateCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _dateCollectionView.backgroundColor = [UIColor whiteColor];
        _dateCollectionView.delegate = self;
        
        _dateCollectionView.dataSource = self;
        
        //注册cell
        [_dateCollectionView registerClass:[GTCalendarCell class] forCellWithReuseIdentifier:NSStringFromClass([GTCalendarCell class])];
        [_dateCollectionView registerClass:[GTCalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([GTCalendarHeaderView class])];
    }
    return _dateCollectionView;
}
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.text = @"选择日期";
        _titleLable.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLable;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"close"] forState:0];
        [_cancelButton addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIView *)weekView {
    if (!_weekView) {
        _weekView = [[UIView alloc] init];
        _weekView.backgroundColor = [UIColor whiteColor];
        for (NSString *wDay in week_days) {
            UILabel *wDayLabel = [[UILabel alloc] initWithFrame:CGRectMake([week_days indexOfObject:wDay]*kScreenWidth/7, 0, kScreenWidth/7, 30)];
            wDayLabel.text = wDay;
            wDayLabel.textAlignment = NSTextAlignmentCenter;
            wDayLabel.font = [UIFont systemFontOfSize:15];
            UIColor* hColor;
            if ([week_days indexOfObject:wDay]==0||[week_days indexOfObject:wDay]==6){
                hColor = [UIColor redColor] ;//周末为红色
            }
            else{
                hColor = [UIColor blackColor];
            }
            wDayLabel.textColor = hColor;
            [_weekView addSubview:wDayLabel];
        }
    }
    return _weekView;
}

- (UILabel *)partLineLabel {
    if (!_partLineLabel) {
        _partLineLabel = [UILabel new];
        _partLineLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _partLineLabel;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kScreenHeight*0.2);
        make.left.right.bottom.equalTo(self.view);
    }];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kScreenHeight*0.2 + 5);
        make.height.equalTo(@40);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLable.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.height.equalTo(@20);
    }];
    
    [_weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    [_partLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weekView.mas_bottom).offset(3);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    [_dateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_partLineLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

@end
