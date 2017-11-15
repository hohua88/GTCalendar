//
//  ViewController.m
//  GTCalendarDemo
//
//  Created by eddy on 2017/11/15.
//  Copyright © 2017年 eddy. All rights reserved.
//

#import "ViewController.h"
#import "GTCalendarController.h"
@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIButton *dateButton;
@property (nonatomic, copy) NSString *selectDate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selcetDate:(id)sender {
    GTCalendarController *controller = [[GTCalendarController alloc] initWithMonthNumber:1 selected:_selectDate];
    controller.view.backgroundColor = [UIColor colorWithRed:113/255 green:113/255 blue:113/255 alpha:0.5];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.callBlock = ^(GTCalendarDayModel *model){
        NSLog(@"callback ==== %@",model);
        _selectDate = [NSString stringWithFormat:@"%ld-%ld-%ld", model.year , model.month, model.day];
        _dateButton.titleLabel.text = [NSString stringWithFormat:@"%ld-%ld",model.month, model.day];
    };
    
    [self presentViewController:controller animated:YES completion:^{
        controller.view.superview.backgroundColor = [UIColor clearColor];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
