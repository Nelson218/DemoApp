//
//  CustomFlowLayout.m
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import "CustomFlowLayout.h"

@interface CustomFlowLayout()
{
    float contentHeight;
}

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *cachedArray;

@end

@implementation CustomFlowLayout

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.cachedArray = [NSMutableArray array];
    
    return self;
}

-(float)GetWidth
{
    UIEdgeInsets insets = self.collectionView.contentInset;
    
    return CGRectGetWidth(self.collectionView.bounds) - (insets.left + insets.right);
}

#pragma mark - IMP methods

//these methods has to be implemented
-(void)prepareLayout
{
    if (self.cachedArray.count == 0)
    {
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            if (self.delegate)
            {
                CGRect itemSize = [self.delegate sizeForItemAtIndexPath:indexPath];
                
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                attributes.frame = itemSize;
                
                contentHeight = MAX(contentHeight, CGRectGetMaxY(itemSize));
                
                [self.cachedArray addObject:attributes];
            }
        }
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray = [NSMutableArray array];
    
    for (int i = 0; i < self.cachedArray.count; i++)
    {
        if (CGRectIntersectsRect(rect, self.cachedArray[i].frame))
        {
            [attributesArray addObject:self.cachedArray[i]];
        }
    }
    
    return attributesArray;
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake([self GetWidth], contentHeight + 20);
}

@end
