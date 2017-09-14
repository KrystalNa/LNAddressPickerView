//
//  LNAddressSelectView.h
//  省市地区三级联动
//
//  Created by Doris on 2017/9/13.
//  Copyright © 2017年 Doris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LNExtension.h"

typedef void(^refreshInfo)(NSString *infoStr);
@interface LNAddressSelectView : UIView
@property (nonatomic,copy) refreshInfo refreshInfoBlock; /**< */
@end
