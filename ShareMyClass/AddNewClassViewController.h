//
//  AddNewClassViewController.h
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/3/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewClassViewController.h"

@interface AddNewClassViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *className;
@property (weak, nonatomic) IBOutlet UITextField *classId;
- (IBAction)addNewClass:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
