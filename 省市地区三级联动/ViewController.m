//
//  ViewController.m
//  省市地区三级联动
//
//  Created by Doris on 2017/9/7.
//  Copyright © 2017年 Doris. All rights reserved.
//

#import "ViewController.h"
#import "LNAddressSelectView.h"

@interface ViewController ()
@property (nonatomic,strong) UILabel *infoLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [selectBtn setTitle:@"点我测试" forState:UIControlStateNormal];
    selectBtn.backgroundColor = [UIColor redColor];
    [selectBtn addTarget:self action:@selector(selectBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 50)];
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:infoLabel];
    _infoLabel = infoLabel;
}

- (void)selectBtnTouchUpInside{
    LNAddressSelectView *pickerView = [[LNAddressSelectView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    pickerView.refreshInfoBlock = ^(NSString *infoStr) {
        weakSelf.infoLabel.text = infoStr;
    };
    [self.view addSubview:pickerView];
}
@end
