//
//  QuestionsViewController.h
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddQuestionViewController.h"
#import "DisplayAnswersViewController.h"

@interface QuestionsViewController : UITableViewController
@property (strong, nonatomic)NSMutableData *receivedData;
@property (strong, nonatomic)NSArray *questions;
@property (nonatomic, strong) AddQuestionViewController *addQuestionViewController;
@property (strong, nonatomic, readwrite) NSString *courseId;
@property (strong, nonatomic) DisplayAnswersViewController *displayAnswersViewController;

@end
