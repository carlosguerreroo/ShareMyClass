//
//  NewClassViewController.h
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class AddNewClassViewController;

@interface NewClassViewController : UIViewController  <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AddNewClassViewController *addNewClassViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *selectedObject;

-(void)inserNewCourseWithCourseId:(NSNumber*)courseId realCourseid:(NSString*) realCourseId andName:(NSString*)name;

@end
