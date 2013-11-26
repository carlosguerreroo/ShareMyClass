//
//  AddQuestionViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 25/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperMethods.h"

@interface AddQuestionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleQuestion;
@property (weak, nonatomic) IBOutlet UITextField *question;
@property (strong, nonatomic, readwrite) NSString *courseId;;

- (IBAction)closekeyboard:(id)sender;
- (IBAction)sendquestion:(id)sender;

@end
