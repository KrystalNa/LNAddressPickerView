//
//  LNAddressSelectView.m
//  省市地区三级联动
//
//  Created by Doris on 2017/9/13.
//  Copyright © 2017年 Doris. All rights reserved.
//

#import "LNAddressSelectView.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface LNAddressSelectView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) NSDictionary *pickerDict;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *districtArray;
@property (strong, nonatomic) NSArray *selectedArray;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIPickerView *myPicker;
@property (strong, nonatomic) UIView *pickerBackView;
@end

@implementation LNAddressSelectView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [self show];
    }
    return self;
}

- (void)show{
    [self getPickerData];
    [self initView];
}

- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)]];
    
    self.pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-(180+30), self.width, 180+30)];
    self.pickerBackView.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:cancelBtn];
    
    UIButton *ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.pickerBackView.width-50, 0, 50, 30)];
    [ensureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    ensureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    ensureBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [ensureBtn addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBackView addSubview:ensureBtn];
    
    self.myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, self.width, 180)];
    _myPicker.delegate = self;
    _myPicker.dataSource = self;
    [self.pickerBackView addSubview:self.myPicker];
    
    [self showPicker];
}

#pragma mark - get data
- (void)getPickerData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    NSString *provencePath = [[NSBundle mainBundle] pathForResource:@"Provence" ofType:@"plist"];
    NSArray *provenceArr = [[NSArray alloc] initWithContentsOfFile:provencePath];
    
    self.pickerDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = provenceArr;
    self.selectedArray = [self.pickerDict objectForKey:[provenceArr objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.districtArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
}

#pragma mark - <UIPickerViewDelegate>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.districtArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.districtArray objectAtIndex:row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:   (NSInteger)component reusingView:(UIView *)view{
    UILabel* label = nil;
    
    CGFloat height = 30;;
    if (height<21) {
        height =21;
    }else{
        height=30;
    }
    
    if (view == nil) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, floor(pickerView.width/3), height)];
        label.textAlignment=NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth=YES;//设置字体大小是否适应lalbel宽度
        
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont systemFontOfSize:20]];
    }
    
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDict objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.districtArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.districtArray = nil;
        }
    }
    
    if (component == 0) {
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.districtArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.districtArray = nil;
        }
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }
    
    [pickerView reloadAllComponents];
}

#pragma mark - action
- (void)showPicker {
    [self addSubview:self.maskView];
    [self addSubview:self.pickerBackView];
    self.maskView.alpha = 0;
    self.pickerBackView.y = self.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBackView.bottom = self.height;
    }];
}

- (void)hidePicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBackView.y = self.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)cancel{
    [self hidePicker];
}

- (void)ensure{
    NSString *province = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    NSString *city = [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    NSString *district = [self.districtArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
    
    NSLog(@"%@%@%@",province,city,district);
    if (self.refreshInfoBlock) {
        self.refreshInfoBlock([NSString stringWithFormat:@"%@ %@ %@",province,city,district]);
    }
    [self hidePicker];
}

@end
