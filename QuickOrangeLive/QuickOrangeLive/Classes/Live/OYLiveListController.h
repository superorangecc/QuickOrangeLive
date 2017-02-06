//
//  OYLiveListController.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/25.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYCategoryPlatformModel.h"
#import "OYCategoryGameModel.h"

typedef enum : NSUInteger {
    PlatformTypeDouYu,
    PlatformTypeHuoMao,
    PlatformTypeZhanQi,
    PlatformTypeXiongMao,
    PlatformTypeHuYa,
    PlatformTypeQuanMin
} PlatformType;

typedef enum : NSUInteger {
    GameTypeDota2,
    GameTypeLoL,
    GameTypeHearthStone,
    GameTypeOW,
    GameTypeCSGO,
    GameTypeMobileLol,
    GameTypeCF,
    GameTypeWow,
    GameTypeOthers
} GameType;

@interface OYLiveListController : UIViewController

@property (strong, nonatomic) OYCategoryPlatformModel *platFormModel;
@property (strong, nonatomic) OYCategoryGameModel *gameModel;
@property (nonatomic) int currentPage;

@end
