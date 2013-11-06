//
//  HelperMethods.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/3/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "HelperMethods.h"

@implementation HelperMethods



-(NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:userDataPlist];
    
}

-(NSString *)FilePath
{
    return userDataPlist;
}


@end
