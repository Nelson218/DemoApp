//
//  APPUtil.m
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import "APPUtil.h"

@implementation APPUtil

+(void)ShowAlertWithTitle:(NSString *)title Message:(NSString *)message FirstButton:(NSString *)firstBtn SecondBtn:(NSString *)secondBtn ForViewController:(UIViewController *)viewController BtnClickedIndex:(void (^)(int btnIndex))btnClicked
{
    //creating weak viewcontroller instance
    __weak typeof(UIViewController) *_viewController = viewController;
    
    UIAlertController *_controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *_firstAction = [UIAlertAction actionWithTitle:firstBtn style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                   {
                                       if (btnClicked)
                                       {
                                           btnClicked(0);
                                       }
                                   }];
    
    [_controller addAction:_firstAction];
    
    if (secondBtn)
    {
        UIAlertAction *_secondAction = [UIAlertAction actionWithTitle:secondBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction *_action)
                                        {
                                            if (btnClicked)
                                            {
                                                btnClicked(1);
                                            }
                                        }];
        
        [_controller addAction:_secondAction];
    }
    
    [_viewController presentViewController:_controller animated:true completion:nil];
}

@end
