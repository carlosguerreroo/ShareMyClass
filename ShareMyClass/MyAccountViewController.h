//
//  MyAccountViewController.h
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CoursesViewController.h"

@interface MyAccountViewController : UIViewController

@property (strong, nonatomic) CoursesViewController *CoursesViewController;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
- (IBAction)myCourses:(id)sender;

@end
