//
//  ViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 07/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewClassViewController.h"
#import "MessagesViewController.h"
#import "RemindersViewController.h"
#import "MyAccountViewController.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//Views
@property (strong, nonatomic) NewClassViewController *NewClassViewController;
@property (strong, nonatomic) MessagesViewController *MessagesViewController;
@property (strong, nonatomic) RemindersViewController *RemindersViewController;
@property (strong, nonatomic) MyAccountViewController *MyAccountViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *courses;

@end
