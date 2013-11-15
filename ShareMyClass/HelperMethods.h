//
//  HelperMethods.h
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/3/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define userDataPlist @"user.plist"

@interface HelperMethods : NSObject
-(NSString *)dataFilePath;
-(NSString *)FilePath;
-(NSString *)userId;
-(UIImage *)profilePicture;
@end
