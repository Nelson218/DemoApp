//
//  DetailCollectionViewCell.m
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import "DetailCollectionViewCell.h"

@implementation DetailCollectionViewCell

-(void)awakeFromNib
{
    [self.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.layer setBorderWidth:1.0f];
    [self.layer setCornerRadius:2.0f];
    
    [self setClipsToBounds:false];
    
    [super awakeFromNib];
}

@end
