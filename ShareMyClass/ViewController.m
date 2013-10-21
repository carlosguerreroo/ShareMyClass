//
//  ViewController.m
//  ShareMyClass
//	Vicente
//  Created by carlos omana on 07/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	// Do any additional setup after loading the view, typically from a nib.
}



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        //Set Title
        self.title = @"Mis clases";
    }
    
    return self;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
			if(!self.NewClassViewController)
			{
				self.NewClassViewController = [[NewClassViewController alloc] initWithNibName:@"NewClassViewController" bundle:nil];
			}
            
           // self.detailViewController.detailItem = nil;
           // self.detailViewController.delegateMaster = self;
        
            [self.navigationController pushViewController:self.NewClassViewController animated:YES];
            break;
			
		case 1:
			if(!self.MessagesViewController)
			{
				self.MessagesViewController = [[MessagesViewController alloc] initWithNibName:@"MessagesViewController" bundle:nil];
			}
            
            [self.navigationController pushViewController:self.MessagesViewController animated:YES];
            break;
			
		case 2:
			if(!self.RemindersViewController)
			{
				self.RemindersViewController = [[RemindersViewController alloc] initWithNibName:@"RemindersViewController" bundle:nil];
			}
            
            [self.navigationController pushViewController:self.RemindersViewController animated:YES];
            break;
			
		case 3:
			if(!self.MyAccountViewController)
			{
				self.MyAccountViewController = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
			}
            
            [self.navigationController pushViewController:self.MyAccountViewController animated:YES];
            break;
			
        default:
            break;
    }

}

@end
