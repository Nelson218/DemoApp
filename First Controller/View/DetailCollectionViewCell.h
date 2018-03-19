//
//  DetailCollectionViewCell.h
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *articleLbl;
@property (nonatomic, weak) IBOutlet UILabel *webTitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *sectionNameLbl;

@end
