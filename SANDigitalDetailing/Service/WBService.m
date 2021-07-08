//
//  WBService.m
//  SANAPP
//
//  Created by SANeForce.com on 05/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "WBService.h"

#import <AFNetworking/AFNetworking.h>
@implementation WBService
- (void)authenticateUser:(NSString *)pUserID
                 withUserPassword:(NSString *)pUserPassword
                       completion:(void (^)(BOOL success,id respData))completionBlock
                            error:(void (^)(NSString *errorMsg)) errorBlock
{
    
    NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
   
    NSString *loginURL=[[NSString alloc] initWithFormat:@"%@login",[ServDet objectForKey:@"baseUrl"]];
    
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setValue:pUserID forKey:@"name"];
    [postDict setValue:pUserPassword forKey:@"password"];
    [postDict setValue:@"7.1" forKey:@"Appver"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:nil];
    
    id postData = @{@"data":[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding]};
    
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    AFHTTPRequestOperation *operation = [manager POST:loginURL
                                          parameters:postData
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 if (completionBlock) {
                                                     completionBlock(YES,responseObject);
                                                 }
                                                 NSLog(@"Success");
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 if (errorBlock) {
                                                     
                                                     NSString *sMsg=@"";
                                                     if(error.code==-1009)
                                                     {
                                                         sMsg=[error.userInfo valueForKey:NSLocalizedDescriptionKey];
                                                     }
                                                     errorBlock(sMsg);
                                                 }
                                                 NSLog(@"Failure:%@",error);
                                             }];
    [operation start];
}

+(void) SendServerRequest:(NSString *)keyString withParameter:(NSMutableDictionary *)Param withImages:(NSMutableDictionary *)uplImages DataSF:(NSString*) DataSF completion:(void (^)(BOOL, id, NSMutableDictionary *))completionBlock
                    error:(void (^)(NSString *errorMsg, NSMutableDictionary *)) errorBlock
{
    [self SendServerRequest:keyString withParameter:Param withImages:uplImages DataSF:DataSF indexPath:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage, NSIndexPath *indexPath) {
        if (completionBlock) {
            completionBlock(YES,respData,DatawithImage);
        }

    } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage, NSIndexPath *indexPath) {
        errorBlock(errorMsg,DatawithImage);
    }];

}
+(void) SendServerRequest:(NSString *)keyString
            withParameter:(NSMutableDictionary *)Param
               withImages:(NSMutableDictionary *)uplImages
                   DataSF:(NSString*) DataSF
                indexPath:(NSIndexPath*) indexPath
               completion:(void (^)(BOOL success,id respData, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath))completionBlock
                    error:(void (^)(NSString *errorMsg, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath)) errorBlock
{
    
    NSMutableDictionary *UserDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails.SANAPP"] mutableCopy];
    NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    
    if(Param==nil) Param=[[NSMutableDictionary alloc] init];
    if(DataSF==nil) DataSF=[UserDet objectForKey:@"SF_Code"];
    [Param setValue:DataSF  forKey:@"SF"];
    [Param setValue:[UserDet objectForKey:@"Division_Code"]  forKey:@"Div"];
    [Param setValue:[UserDet objectForKey:@"SF_Code"]  forKey:@"APPUserSF"];
    [Param setValue:stringFromDate forKey:@"ReqDt"];
    
    
    NSString *sURL=[[NSString alloc] initWithFormat:@"%@%@",[ServDet objectForKey:@"baseUrl"],keyString];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Param options:0 error:nil];
    
    id postData = @{@"data":[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding]};
    
    //id postData = @{@"data":[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding]};
    
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    AFHTTPRequestOperation *operation = [manager POST:sURL
           parameters:postData
         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             if(uplImages!=nil){
                 [formData appendPartWithFileData:[[uplImages mutableCopy] objectForKey:@"Image"] name:[[uplImages mutableCopy] valueForKey:@"Key"] fileName:[[uplImages mutableCopy] valueForKey:@"Filename"] mimeType:@"image/png"];
             }
         }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (completionBlock) {
                      /*NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                      if([receivedDta count]>0){
                          if([[receivedDta[0] valueForKey:@"success"] boolValue]==NO){
                              [Param setValue:[NSNumber numberWithBool:NO] forKey:@"Synced"];
                          }else{
                              [Param setValue:[NSNumber numberWithBool:YES] forKey:@"Synced"];
                          }
                      }*/
                      [Param setValue:[NSNumber numberWithBool:YES] forKey:@"Synced"];
                      if(uplImages!=nil){
                          [Param setObject:uplImages forKey:@"uImages"];
                      }
                      completionBlock(YES,responseObject,Param,indexPath);
                  }
                  NSLog(@"Success: %@ ***** %@",keyString, operation.responseString);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  if (errorBlock) {
                      if(uplImages!=nil){
                          [Param setObject:uplImages forKey:@"uImages"];
                      }
                      [Param setValue:[NSNumber numberWithBool:NO] forKey:@"Synced"];
                      errorBlock(error.description,Param,indexPath);
                  }
                  NSLog(@"Failure:%@",error.description);
              }];
    [operation start];
}

+(void)getUrlData:(NSString*)url ContentType:(NSString *)ContentType Data:(NSMutableDictionary*) data completion:(void (^)(BOOL, id))completionBlock
            error:(void (^)(NSString *errorMsg)) errorBlock
{
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
    AFHTTPRequestOperation *operation = [manager POST:url
                                           parameters:data
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  if (completionBlock) {
                                                      completionBlock(YES,responseObject);
                                                  }
                                                  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                              }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  
                                                  if (errorBlock) {
                                                      errorBlock(error.description);
                                                  }
                                                  NSLog(@"Failure:%@",error.description);
                                              }];
    [operation start];

}
+(NSString *)uploadFileToServer:(NSMutableDictionary *)uFormData{
    NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
    NSString *sURL=[[NSString alloc] initWithFormat:@"%@upload/files",[ServDet objectForKey:@"baseUrl"]];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *op = [manager POST:sURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[[uFormData mutableCopy] objectForKey:@"File"] name:[[uFormData mutableCopy] valueForKey:@"Key"] fileName:[[uFormData mutableCopy] valueForKey:@"Filename"] mimeType:@"application/octet-stream"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    return @"";
}
/*+(NSString *)uploadFileToServer:(NSString *)FullPath FileName:(NSString*) fileName{
    NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
 
    * creating path to document directory and appending filename with extension*

    *NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths objectAtIndex:0];*

    NSString *filePath = [FullPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];//[documentsDirectory stringByAppendingPathComponent:fileName];

    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:filePath];

    NSString *urlString=[[NSString alloc] initWithFormat:@"%@upload/files",[ServDet objectForKey:@"baseUrl"]];
    * creating URL request to send data *

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:urlString]];

    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"—————————14737809831466499882746641449";

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];

    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];

    * adding content as a body to post *

    NSMutableData *body = [NSMutableData data];

    NSString *header = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".%@\"\r\n",@"AFile",[fileName pathExtension]];
    [body appendData:[[NSString stringWithFormat:@"\r\n–%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithString:header] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[NSData dataWithData:file1Data]];

    [body appendData:[[NSString stringWithFormat:@"\r\n–%@–\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];

    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] ;

    return returnString;


}*/
+(void) uplodeScribbleImages:(NSMutableDictionary *) uplImages{
    NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
    NSString *sURL=[[NSString alloc] initWithFormat:@"%@upload/scribble",[ServDet objectForKey:@"baseUrl"]];
    
    /*AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    AFHTTPRequestOperation *operation = [manager POST:sURL
                                           parameters:nil
                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                if(uplImages!=nil){
                                    [formData appendPartWithFileData:[[uplImages mutableCopy] objectForKey:@"Image"] name:[[uplImages mutableCopy] valueForKey:@"Key"] fileName:[[uplImages mutableCopy] valueForKey:@"Filename"] mimeType:@"image/png"];
                                }
                            }
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  NSLog(@"Success: ***** %@", operation.responseString);
                                              }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Failure:%@",error.description);
                                              }];
    [operation start];*/
  
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *op = [manager POST:sURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[[uplImages mutableCopy] objectForKey:@"Image"] name:[[uplImages mutableCopy] valueForKey:@"Key"] fileName:[[uplImages mutableCopy] valueForKey:@"Filename"] mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
}
+(void) uplodeImages:(NSData *) imageData{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager   alloc] initWithBaseURL:[NSURL URLWithString:@"http://trial.saneforce.info/iOSServer/Signs"]];
    AFHTTPRequestOperation *op = [manager POST:@"cat1.png" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         [formData appendPartWithFileData:imageData name:@"userfile" fileName:@"cat1.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
}
+(void) saveArrayData:(NSMutableArray *)ServerDetail
          forKey:(NSString *)keyString
{
    [[NSUserDefaults standardUserDefaults] setObject:ServerDetail forKey:keyString];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(void) saveData:(NSDictionary *)ServerDetail
          forKey:(NSString *)keyString
{
    [[NSUserDefaults standardUserDefaults] setObject:ServerDetail forKey:keyString];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSMutableDictionary *) getDataByKey:(NSString*) KeyString
{
    return  [[[NSUserDefaults standardUserDefaults] objectForKey:KeyString] mutableCopy];
}
-(void) saveServerDetails:(NSMutableDictionary *)ServerDetail
{
    [[NSUserDefaults standardUserDefaults] setObject:ServerDetail forKey:@"ServerDet.SANConfigAPP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) ClearAllData{
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        if([key containsString:@".SANAPP"]==true ||[key containsString:@".SANConfigAPP"]==true ){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@NO forKey:@"flag"];
    
    [WBService saveData:dict forKey:@"dataLoaded"];
}
@end
