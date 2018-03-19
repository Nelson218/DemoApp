//
//  ServiceClass.h
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceClass : NSObject

@property (nonatomic, strong, readonly) NSURLSessionDataTask *mainTask;

-(NSURLSessionDataTask *)StartServiceForURL:(NSString *)urlString
                                 WithMethod:(NSString *)httpMethod
                                       Body:(NSDictionary *)body
                                HTTPHeaders:(NSDictionary *)headers
                                SucessBlock:(void (^)(id))sucessBlock
                               FailureBlock:(void (^)(id))failureBlock;

@end
