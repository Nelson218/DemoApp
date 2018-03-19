//
//  ServiceClass.m
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import "ServiceClass.h"

@interface ServiceClass()

@property (nonatomic, nonnull, copy) void(^sucessBlock)(id);
@property (nonatomic, nonnull, copy) void(^failureBlock)(id);

@end

@implementation ServiceClass

-(NSURLSessionDataTask *)StartServiceForURL:(NSString *)urlString WithMethod:(NSString *)httpMethod Body:(NSDictionary *)body HTTPHeaders:(NSDictionary *)headers SucessBlock:(void (^)(id))sucessBlock FailureBlock:(void (^)(id))failureBlock
{
    //first we are copying our blocks so that they won't go out of memory
    self.sucessBlock = sucessBlock;
    self.failureBlock = failureBlock;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:httpMethod];
    request.timeoutInterval = 30.0f;
    
    //if headers present
    if (headers)
    {
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    //if body is present
    if (body)
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
        
        if(error == nil)
        {
            [request setHTTPBody:jsonData];
        }
        else
        {
            NSLog(@"JSON parsing error %@",error);
        }
    }
    
    _mainTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil && data)
        {
            //no error check status code
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode == 200)
            {
                //recived the response
                //parse the data
                
                NSError *jsonError;
                id responseObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                if (jsonError == nil)
                {
                    if (self.sucessBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.sucessBlock(responseObj);
                        });
                    }
                }
                else
                {
                    if (self.failureBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.failureBlock(@{@"message" : @"Server response is not Json",
                                                @"value" : data
                                                });
                        });
                    }
                }
            }
            else
            {
                //status code is different
                //means error from server side
                if (self.failureBlock)
                {
                    NSError *jsonError;
                    id responseObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    
                    if (jsonError == nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.failureBlock(@{@"message" : @"Error from server side",
                                                @"value" : data
                                                });
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.failureBlock(responseObj);
                        });
                    }
                }
            }
        }
        else
        {
            //error while connecting server
            
            if (self.failureBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.failureBlock(error);
                });
            }
        }
        
    }];
    
    [_mainTask  resume];
    
    return _mainTask;
}

@end
