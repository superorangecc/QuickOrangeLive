//
//  OYCategoryRightCell.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/24.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYCategoryPlatformModel.h"
@class OYCategoryRightCell;

@protocol OYCategoryRightCellDelegate <NSObject>

@optional
- (void)oyCategoryRightCell:(OYCategoryRightCell *)categoryRightCell didSelectGameCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface OYCategoryRightCell : UICollectionViewCell

@property (strong, nonatomic) OYCategoryPlatformModel *model;
@property (weak, nonatomic) id<OYCategoryRightCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *currentPlatFormIndexPath;


@end
