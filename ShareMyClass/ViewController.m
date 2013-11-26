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

/*
 Nombre: viewDidLoad
 Uso: Método que se llama cuando se carga la vista
 */
- (void)viewDidLoad
{
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [super viewDidLoad];
		
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    [self.collectionView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.0]];
    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];
    
    self.folderImage = [UIImage imageNamed:@"folder.png"];

}

/*
 Nombre: viewWillAppear
 Uso: Método que se ejecuta antes de que aparezca la vista
 */

-(void)viewWillAppear:(BOOL)animated
{
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    self.fetchedResultsController = nil;
    [self.collectionView reloadData];
    
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
/*
 Nombre: didSelectItem
 Uso: Método para el momento de seleccionar una opcion del menu principal
 */
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
                AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                self.MessagesViewController.managedObjectContext = appDelegate.managedObjectContext;

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

/*
 Nombre: collectionView numberOfItemsInSection
 Uso: Método que agrega cada collection cell
 */


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

/*
 Nombre:  collectionView cellForItemAtIndexPath
 Uso: Método que agrega cada collection cell
 */

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

   
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIImageView *folder =[[UIImageView alloc] initWithImage:self.folderImage];
    for (UIView *view in cell.contentView.subviews) //Revisaar
        [view removeFromSuperview];
    
    UILabel  *courseName = [[UILabel alloc] initWithFrame:CGRectMake(-20, 80, 130, 20)];
    courseName.text = [[object valueForKey:@"courseName"] description];
    [courseName setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.0]];
    [courseName setTextColor:[UIColor whiteColor]];
    courseName.font=[courseName.font fontWithSize:13];
    courseName.textAlignment = NSTextAlignmentCenter;
    [folder insertSubview:courseName atIndex:0];
    [cell.contentView insertSubview:folder atIndex:0];
    
    return cell;
}

/*
 Nombre: collectionView didSelectItemAtIndexPath
 Uso: Método que se ejecuta al seleccionar un collection cell
 */

-	(void)	collectionView:(UICollectionView	*)collectionView
didSelectItemAtIndexPath:(NSIndexPath	*)indexPath
{
    if (!self.FilesViewController) {
        self.FilesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
    }
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    self.FilesViewController.courseId = [[object valueForKey:@"courseId"] description].intValue;
    self.FilesViewController.delegateFiles = self;
    [self.navigationController pushViewController:self.FilesViewController animated:YES];
    

}

/*
 Nombre: loginFailed
 Uso: Método que carga los métodos de la entidad
 */

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Courses" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"courseId" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {

	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}



@end
