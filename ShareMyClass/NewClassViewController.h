//
//  NewClassViewController.h
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddNewClassViewController;

@interface NewClassViewController : UIViewController
@property (strong, nonatomic) AddNewClassViewController *addNewClassViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
