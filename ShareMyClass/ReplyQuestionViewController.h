//
//  ReplyQuestionViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 25/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyQuestionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *bodyReply;
@property (strong, nonatomic) NSString *idReply;
- (IBAction)reply:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@property(strong, nonatomic)NSMutableData *receivedData;

@end
