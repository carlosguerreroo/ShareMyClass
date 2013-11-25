//
//  ViewFileViewController.h
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFileViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageOutlet;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOutlet;
@property (weak, nonatomic) IBOutlet UILabel *titleOutlet;
@property (weak, nonatomic) IBOutlet UILabel *dateOutlet;
@property NSString *url;
@property NSString *name;
@property NSString *date;
@property NSString *description;
- (IBAction)download:(id)sender;

@end
