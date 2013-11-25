//
//  FilesViewController.h
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionsViewController.h"
#import "ViewFileViewController.h"
#import "NewFileViewController.h"


@class NewFileViewController;


@interface FilesViewController : UITableViewController

@property (strong, nonatomic) FilesViewController *delegateFiles;
@property (strong, nonatomic) NewFileViewController *NewFileViewController;
@property (strong, nonatomic) QuestionsViewController *QuestionsViewController;
@property (strong, nonatomic) ViewFileViewController *ViewFileViewController;

-(void)removeView;
@property int courseId;

@end
