//
//  OYCategoryLeftCell.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/23.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYCategoryPlatformModel.h"

@interface OYCategoryLeftCell : UITableViewCell

/** 分类标题 */
@property (weak, nonatomic) UILabel *categoryLabel;
/** 模型对象 */
@property (strong, nonatomic) OYCategoryPlatformModel *model;


@end
