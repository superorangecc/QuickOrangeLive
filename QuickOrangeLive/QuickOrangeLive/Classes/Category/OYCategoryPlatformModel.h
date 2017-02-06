//
//  OYCategoryPlatformModel.h
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/24.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OYCategoryGameModel.h"

@interface OYCategoryPlatformModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *bannerpic;
@property (nonatomic) NSInteger platformid;

@property (strong, nonatomic) NSArray<OYCategoryGameModel *> *categories;


@end
