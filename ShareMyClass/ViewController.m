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
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [super viewDidLoad];
	
    [self.collectionView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.0]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar-Wood"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];
    
   // UIImage *p1 = [UIImage imageNamed:@"folder.png"];
   // UIImageView *vista1 = [[UIImage alloc] initWithImage: p1];
    // add to array
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    /*
     
    UIImageView *vista = [self.datos objectAtIndex: [indexPath row]];
     
     
    [cell.contentView addSubview:vista];
    */
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"folder.png"]];
    
    return cell;
}


/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(130, 136);
}*/


@end
