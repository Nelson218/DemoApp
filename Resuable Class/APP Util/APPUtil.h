//
//  APPUtil.h
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface APPUtil : NSObject

+(void)ShowAlertWithTitle:(NSString *)title
                  Message:(NSString *)message
              FirstButton:(NSString *)firstBtn
                SecondBtn:(NSString *)secondBtn
        ForViewController:(UIViewController *)viewController
          BtnClickedIndex:(void (^)(int btnIndex))btnClicked;

@end
