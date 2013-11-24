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
@property (weak, nonatomic) IBOutlet UILabel *nameOutlet;
@property NSString *imageName;
@end
