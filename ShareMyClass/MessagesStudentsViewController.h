//
//  MessagesStudentsViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 07/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesInterfaceViewController.h"

@interface MessagesStudentsViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *selectedCourse;
@property (nonatomic, strong) NSArray *students;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) MessagesInterfaceViewController *messageInterfaceViewController;

@end

