//
//  APIClass.h
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIClass : NSObject

+(NSURLSessionDataTask *)GetTheCountryDataFromURL:(NSString *)urlString
                                      SucessBlock:(void (^)(id responseObj))sucessBlock
                                     FailureBlock:(void (^)(id failureObj))failureBlock;

@end
