//
//  List.h
//  SANAPP
//
//  Created by SANeForce.com on 25/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject

@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* label;

@property (nonatomic, strong) NSString* apiPath;
@property (nonatomic, strong) NSMutableDictionary* param;

-(id)initWithCode:(NSString*)code andName:(NSString*)name;
-(id)initWithName:(NSString*)name andApiPath:(NSString*)path Parameters:(NSMutableDictionary *)Param;
-(id)initWithName:(NSString *)name andLabel:(NSString *)label andApiPath:(NSString *)path Parameters:(NSMutableDictionary *)Param;
@end
