//
//  ViewController.m
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import "ViewController.h"
#import "APIClass.h"
#import "APPUtil.h"
#import "CountryDetailModel.h"
#import "CustomFlowLayout.h"
#import "DetailCollectionViewCell.h"
#import "DetailViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CustomFlowLayoutDelegate>
{
    float spacing;
    int prevSelectedCellIndex;
    bool keepTrackOfAllVisitedCell;
    bool differentHeight;
}

@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSMutableArray<CountryDetailModel *> *mainArray;
@property (nonatomic, weak) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic, weak) IBOutlet UIView *loaderView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.countryName = @"syria";
    spacing = 10;
    prevSelectedCellIndex = -1;
    [self showLoaderView:false];
    
    //toggle this for different output
    keepTrackOfAllVisitedCell = false;
    differentHeight = false;

    //get refrence for layout
    CustomFlowLayout *layout = (CustomFlowLayout *)self.mainCollectionView.collectionViewLayout;
    [layout setDelegate:self];
    
    [self GetData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    //when we come back from detail controller we wanted to reload data as it will change color of prev selected cell
    if (self.mainArray)
    {
        [self.mainCollectionView reloadData];
    }
    
    [super viewWillAppear:animated];
}

-(void)showLoaderView:(BOOL)show
{
    [self.loaderView setHidden:!show];
    
    if(show)
        [self.activityIndicator startAnimating];
    else
        [self.activityIndicator stopAnimating];
}

#pragma mark - API

-(void)GetData
{
    //creating weak self, so it won't get retain in memory
    __weak typeof(ViewController) *_self = self;
    
    [self showLoaderView:true];

    NSString *url = [NSString stringWithFormat:@"https://content.guardianapis.com/search?q=%@&api-key=test",self.countryName];
    
    //following class return NSURLSessionDataTask, if we want we assign it to some variable and then stop/cancel the task
    [APIClass GetTheCountryDataFromURL:url SucessBlock:^(id responseObj)
     {
         [_self showLoaderView:false];
         if ([responseObj isKindOfClass:[NSDictionary class]])
         {
             [_self DecompileData:(NSDictionary *)responseObj];
         }
         
     } FailureBlock:^(id failureObj)
     {
         [_self showLoaderView:false];

         NSString *message = @"Error Occuared";
         
         if ([failureObj isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *errorObj = (NSDictionary *)failureObj;
             
             if (errorObj[@"message"])
             {
                 message = errorObj[@"message"];
             }
         }
         
         [APPUtil ShowAlertWithTitle:@"Error" Message:message FirstButton:@"Ok" SecondBtn:@"Retry" ForViewController:_self BtnClickedIndex:^(int btnIndex) {
             if (btnIndex == 1)
             {
                 [_self GetData];
             }
         }];
     }];
}

-(void)DecompileData:(NSDictionary *)responseObj
{
    //first checking if results array is there
    if(responseObj[@"response"][@"results"] == nil)
    {
        return;
    }
    
    NSArray<NSDictionary *> *resultArray = responseObj[@"response"][@"results"];
    
    //if previously we added values in main array then remove them
    if (self.mainArray)
    {
        [self.mainArray removeAllObjects];
        self.mainArray = nil;
    }
    
    self.mainArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //just assining some values
    //we can play with those
    float width = self.mainCollectionView.frame.size.width - (spacing * 2);
    float height = 100;
    int row = 1;//don't change
    CGRect prevRect = CGRectZero;
    
    for (int i = 0; i < resultArray.count; i++)
    {
        NSDictionary *currentDict = resultArray[i];
        
        CGRect rectOfItem = CGRectMake(spacing,
                                       prevRect.origin.y + spacing + prevRect.size.height,
                                       width,
                                       height);
        
        [self.mainArray addObject:[self createModelForDict:currentDict
                                                      Size:rectOfItem]];
        
        CGRect prevSecondRowItemSize = CGRectZero;
        float maxHeight = height;
        
        for (int j = 0; j < 2; j++)
        {
            //for next row
            //we are showing 2 columns
            i += 1;
            row += 1;
            
            if (i >= resultArray.count)
            {
                break;
            }
            
            //depends on bool value it will give you new height
            float newHeight = differentHeight ? [self getRandomNumb] == 1 ? height + 100 : height : height;
            
            NSDictionary *nextDict = resultArray[i];
            float widthOfSecondRowItem = (width * .5f) - spacing;
            CGRect secondRowRectOfItem = CGRectMake(prevSecondRowItemSize.origin.x + spacing + prevSecondRowItemSize.size.width,
                                                    rectOfItem.origin.y + height + spacing,
                                                    widthOfSecondRowItem,
                                                    newHeight);
            
            maxHeight = MAX(secondRowRectOfItem.size.height,
                            prevSecondRowItemSize.size.height);
            
            prevSecondRowItemSize = secondRowRectOfItem;

            [self.mainArray addObject:[self createModelForDict:nextDict
                                                          Size:secondRowRectOfItem]];
        }
        
        prevRect = prevSecondRowItemSize;
        prevRect.size.height = maxHeight;
        
        row += 1;
    }
    
    [self.mainCollectionView reloadData];
}

-(int)getRandomNumb
{
    int lowerBound = 0;
    int upperBound = 2;
    return lowerBound + arc4random() % (upperBound - lowerBound);
}

-(CountryDetailModel *)createModelForDict:(NSDictionary *)dict Size:(CGRect)rect
{    
    CountryDetailModel *model = [CountryDetailModel new];
    
    if(dict[@"type"]) model.article = dict[@"type"];
    if(dict[@"sectionName"]) model.sectionName = dict[@"sectionName"];
    if(dict[@"webUrl"]) model.webUrl = dict[@"webUrl"];
    if(dict[@"webTitle"]) model.webTitle = dict[@"webTitle"];
    
    model.blockRect = rect;
    
    return model;
}

#pragma mark - collection view

-(CGRect)sizeForItemAtIndexPath:(NSIndexPath *)path
{
    return self.mainArray[path.row].blockRect;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mainArray ? self.mainArray.count : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionViewCell *cell = (DetailCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCollectionViewCelliDentifier" forIndexPath:indexPath];
    
    CountryDetailModel *model = self.mainArray[indexPath.row];
    
    cell.sectionNameLbl.text = model.sectionName;
    cell.webTitleLbl.text = model.webTitle;
    cell.articleLbl.text = model.article;
    cell.backgroundColor = model.isSelected ? [UIColor cyanColor] : [UIColor whiteColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!keepTrackOfAllVisitedCell)
    {
        if (prevSelectedCellIndex >= 0)
        {
            self.mainArray[prevSelectedCellIndex].isSelected = false;
        }
        
        prevSelectedCellIndex = (int)indexPath.row;
    }
    
    CountryDetailModel *currentModel = self.mainArray[indexPath.row];
    currentModel.isSelected = true;
    
    [self openDetailViewControllerForModel:self.mainArray[indexPath.row]];
}

#pragma mark - load view controller

-(void)openDetailViewControllerForModel:(CountryDetailModel *)model
{
    DetailViewController *detailController = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detailViewControllerID"];
    detailController.model = model;
    
    [self.navigationController pushViewController:detailController animated:true];
}

@end
