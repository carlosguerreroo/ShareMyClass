//
//  DisplayAnswersViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 25/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyQuestionViewController.h"
@interface DisplayAnswersViewController : UITableViewController

@property(nonatomic, strong)NSString *questionId;
@property(strong, nonatomic)NSMutableData *receivedData;
@property(strong,nonatomic)NSArray *answers;
@property(strong, nonatomic)ReplyQuestionViewController *replyQuestionViewController;
@end
