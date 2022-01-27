//
//  List.m
//  SANAPP
//
//  Created by SANeForce.com on 25/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "List.h"

@implementation List

-(id)initWithName:(NSString *)name andApiPath:(NSString *)path Parameters:(NSMutableDictionary *)Param{
    return [self initWithName:name andLabel:@"" andApiPath:path Parameters:Param];
}
-(id)initWithCode:(NSString *)code andName:(NSString *)name{
    
    self = [super init];
    if(self){
        self.code = code;
        self.name = name;
    }
    return self;
}
-(id)initWithName:(NSString *)name andLabel:(NSString *)label andApiPath:(NSString *)path Parameters:(NSMutableDictionary *)Param{
    
    self = [super init];
    if(self){
        self.name = name;
        self.label=label;
        self.apiPath = path;
        self.param = Param;
    }
    return self;
}
@end
