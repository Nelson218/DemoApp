//
//  CustomFlowLayout.h
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomFlowLayoutDelegate<NSObject>

-(CGRect)sizeForItemAtIndexPath:(NSIndexPath *)path;

@end

@interface CustomFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CustomFlowLayoutDelegate> delegate;

@end
