//
//  APIClass.m
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import "APIClass.h"
#import "ServiceClass.h"

@implementation APIClass

+(NSURLSessionDataTask *)GetTheCountryDataFromURL:(NSString *)urlString SucessBlock:(void (^)(id))sucessBlock FailureBlock:(void (^)(id))failureBlock
{
    //normal setting values and starting the task
    
    ServiceClass *service = [ServiceClass new];
    
    [service StartServiceForURL:urlString WithMethod:@"GET" Body:nil HTTPHeaders:nil SucessBlock:sucessBlock FailureBlock:failureBlock];
    
    return service.mainTask;
}

@end
