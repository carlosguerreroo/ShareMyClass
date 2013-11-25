//
//  NewFileViewController.h
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFileViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIImageView *showImageOutlet;
@property (weak, nonatomic) IBOutlet UITextField *titleOutlet;
@property (weak, nonatomic) IBOutlet UITextField *descriptionOutlet;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) UITextField *activeField;

- (void)registerForKeyboardNotifications;
@property int courseId;


- (IBAction)chooseImage:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)uploadPhoto:(id)sender;

- (IBAction)dismiss:(id)sender;


@end
