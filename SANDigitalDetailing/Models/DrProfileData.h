//
//  DrProfileData.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 19/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrProfileData : NSObject

    @property (nonatomic,assign) NSString* ProfType;
    @property (nonatomic,weak) NSString* CustCode;
    @property (nonatomic,weak) NSString* CustName;
    @property (nonatomic,weak) NSString* Entry_location;

    @property (nonatomic,assign) NSString* DrGender;
    @property (nonatomic,assign) NSString* DrQual;
    @property (nonatomic,assign) NSString* DrSpec;
    @property (nonatomic,assign) NSString* DrCat;
    @property (nonatomic,assign) NSString* DrType;

    @property (nonatomic,assign) NSString* DrDOBD;
    @property (nonatomic,assign) NSString* DrDOBM;
    @property (nonatomic,assign) NSString* DrDOWD;
    @property (nonatomic,assign) NSString* DrDOWM;
    @property (nonatomic,assign) NSString* DrDOBY;
    @property (nonatomic,assign) NSString* DrDOWY;

    @property (nonatomic,assign) NSString* DrAdd1;
    @property (nonatomic,assign) NSString* DrAdd2;
    @property (nonatomic,assign) NSString* DrAdd3;
    @property (nonatomic,assign) NSString* DrAdd4;
    @property (nonatomic,assign) NSString* DrAdd5;

    @property (nonatomic,assign) NSString* DrMob;
    @property (nonatomic,assign) NSString* DrPhone;
    @property (nonatomic,assign) NSString* DrEmail;

    @property (nonatomic,assign) NSString* DrTar;
    @property (nonatomic,assign) NSString* DrClass;
    @property (nonatomic,retain) NSString* DrHosp;
    @property (nonatomic,retain) NSString* DrHospNm;
    @property (nonatomic,assign) NSString* ContactPerson;
    @property (nonatomic,retain) NSMutableArray* Products;
    @property (nonatomic,retain) NSMutableArray* DrVisits;

    @property (nonatomic,retain) NSMutableArray* VisitDays;
    @property (nonatomic,retain) NSMutableArray* VstSess;
    @property (nonatomic,retain) NSMutableArray* vstAvgPDy;
    @property (nonatomic,retain) NSMutableArray* vstEcoPats;
    @property (nonatomic,retain) NSMutableArray* AdditionalCtrls;


+(DrProfileData *)sharedDatas;
-(void)clearDrProfile;
- (NSMutableDictionary *)toNSDictionary;
@end

NS_ASSUME_NONNULL_END
