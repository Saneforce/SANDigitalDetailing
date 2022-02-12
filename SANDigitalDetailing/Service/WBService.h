//
//  WBService.h
//  SANAPP
//
//  Created by SANeForce.com on 05/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBService : NSObject
    @property (nonatomic,weak) NSString *loginURL ;

+(void) saveData:(NSMutableDictionary *)ServerDetail
          forKey:(NSString *)keyString;
+(NSArray*)removeNullValues:(NSArray *)arrData;
+(void) saveArrayData:(NSMutableArray *)ServerDetail
               forKey:(NSString *)keyString;
+(NSMutableDictionary *) getDataByKey:(NSString*) KeyString;
+(void) ClearAllData;
-(void) authenticateUser:(NSString *)pUserEmail
         withUserPassword:(NSString *)pUserPassword
              completion:(void (^)(BOOL success,id respData))completionBlock
                   error:(void (^)(NSString *errorMsg)) errorBlock;

+(void) SendServerRequest:(NSString *)keyString
            withParameter:(NSMutableDictionary *)Param
               withImages:(NSMutableDictionary *)uplImages
                   DataSF:(NSString*) DataSF
                indexPath:(NSIndexPath*) indexPath
               completion:(void (^)(BOOL success,id respData, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath))completionBlock
                    error:(void (^)(NSString *errorMsg, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath)) errorBlock;

+(void) SendServerRequest:(NSString *)keyString
            withParameter:(NSMutableDictionary *)Param
               withImages:(NSMutableDictionary *)uplImages
                   DataSF:(NSString*) DataSF
               completion:(void (^)(BOOL success,id respData, NSMutableDictionary *DatawithImage))completionBlock
                    error:(void (^)(NSString *errorMsg, NSMutableDictionary *DatawithImage)) errorBlock;
+(void)getUrlData:(NSString*)url ContentType:(NSString *)ContentType Data:(NSMutableDictionary*) data completion:(void (^)(BOOL, id))completionBlock
            error:(void (^)(NSString *errorMsg)) errorBlock;
-(void) saveServerDetails:(NSMutableDictionary *)ServerDetail;

+(NSString *)uploadFileToServer:(NSMutableDictionary *)uFormData;
//+(NSString *)uploadFileToServer:(NSString *)FullPath FileName:(NSString*) fileName;
+(void) uplodeScribbleImages:(NSData *) imgdata;
+(void) uplodeImages:(NSData *) imgdata;
@end
