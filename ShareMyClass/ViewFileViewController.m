//
//  ViewFileViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "ViewFileViewController.h"

@interface ViewFileViewController ()

@end

@implementation ViewFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.title = self.name;
    self.titleOutlet.text = self.name;
    self.dateOutlet.text = self.date;
    self.descriptionOutlet.text = self.description;
    
    NSString *ImageURL = [NSString stringWithFormat:@"http://192.241.224.160/ShareMyClass/ShareMyClassApi/uploads/%@",self.url];
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
	self.imageOutlet.image =  [UIImage imageWithData:imageData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)download:(id)sender {
     NSString *ImageURL = [NSString stringWithFormat:@"http://192.241.224.160/ShareMyClass/ShareMyClassApi/uploads/%@",self.url];
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]]];
    
	
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:finishedSavingWithError:contextInfo:),
                                   nil);

}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"Error al guardar"
                              delegate: nil
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Éxito"
                              message: @"Imagen guardada correctamente en álbum de fotos"
                              delegate: nil
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil];
        [alert show];
        
    }
}
@end
