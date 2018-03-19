//
//  CountryDetailModel.h
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CountryDetailModel : NSObject

@property (nonatomic, strong) NSString *article;
@property (nonatomic, strong) NSString *sectionName;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, assign) CGRect blockRect;
@property (nonatomic, assign) BOOL isSelected;
@end
