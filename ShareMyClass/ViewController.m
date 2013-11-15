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
	
	
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];

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
                AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                self.NewClassViewController.managedObjectContext = appDelegate.managedObjectContext;
			}
            
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
                
                AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                self.RemindersViewController.managedObjectContext = appDelegate.managedObjectContext;
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

//==============DEBUG AREA===============

- (IBAction)insert:(id)sender
{
 
    [self inserNewMessageWithFrom:@"601213713" To:@"691021250" Date:[NSDate date] andMessage:@"Hola"];
    [self inserNewMessageWithFrom:@"601213713" To:@"691021250" Date:[NSDate date] andMessage:@"Hola"];
    [self inserNewMessageWithFrom:@"691021250" To:@"601213713" Date:[NSDate date] andMessage:@"Hola"];
    [self inserNewMessageWithFrom:@"601213713" To:@"691021250" Date:[NSDate date] andMessage:@"Hola"];
    [self inserNewMessageWithFrom:@"601213713" To:@"691021250" Date:[NSDate date] andMessage:@"Hola"];
    [self inserNewMessageWithFrom:@"601213713" To:@"691021250" Date:[NSDate date] andMessage:@"Hola"];
    [self inserNewMessageWithFrom:@"771276037" To:@"601213713" Date:[NSDate date] andMessage:@"Hola"];

    
    
}

- (IBAction)select:(id)sender
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Message" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    //NSNumber *minimumSalary = ...;
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:
    //                          @"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
   // [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:
    //                          @"(from = 691021250) OR (to = 691021250 )"];
    ///[request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        // Deal with error...
    }
    
    //[[array objectAtIndex:0] valueForKey@"message"]
    
    for(NSManagedObject* object in array){
    
        NSLog(@"%@",[object valueForKey:@"from"]);
        
    }
    //NSLog(@"%@",array);
    
}

-(void)inserNewMessageWithFrom:(NSString*)from To:(NSString*)to Date:(NSDate*)date andMessage:(NSString*)message
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *courseObject = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Message"
                                     inManagedObjectContext:context];
    
    [courseObject setValue: from  forKey:@"from"];
    [courseObject setValue: to forKey:@"to"];
    [courseObject setValue: message forKey:@"message"];
    [courseObject setValue: date forKey:@"date"];
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
