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

-(NSString *)userId
{
    NSString *filePath = [self dataFilePath];
    NSString *studentId;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        studentId = [[NSString alloc]initWithString:[dataDictionary objectForKey:@"id"]];
    }

    return studentId;
}

-(NSString *)FilePath
{
    return userDataPlist;
}

-(UIImage *)profilePicture
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *profilePictureFilePath = [NSString stringWithFormat:@"%@/profilePicture.png",docDir];
    UIImage *profilePicture = [UIImage imageWithData: [[NSData alloc] initWithContentsOfFile:profilePictureFilePath]];
    
    if(!profilePicture)
    {
        [FBRequestConnection
         startWithGraphPath:@"me?fields=picture.height(50)"
         completionHandler:^(FBRequestConnection *connection,
                             id result,
                             NSError *error) {
             if (!error)
             {
                 UIImage *profilePicture  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:result[@"picture"][@"data"][@"url"]]]];
                 NSData *dataPicture = [NSData dataWithData:UIImagePNGRepresentation(profilePicture)];
                 [dataPicture writeToFile:profilePictureFilePath atomically:YES];
                 
                 
             }
         }];
        return profilePicture;

    }else{
        
        return profilePicture;
        
    }
    

}

@end
