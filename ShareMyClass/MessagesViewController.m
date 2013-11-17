//
//  MessagesViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesGroupsViewController.h"
#import "AppDelegate.h"
@interface MessagesViewController ()

@end

@implementation MessagesViewController

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
    self.students = [[NSMutableArray alloc]init];
    [super viewDidLoad];
	self.title = @"Mensajes";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(viewGroups)]];
    [self searchStudents];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Jala para refrescar"];
    [refresh addTarget:self
            action:@selector(refreshView:)
            forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    refresh.tintColor = [UIColor brownColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewGroups
{

    if(!self.messagesGroupsViewController)
    {
        self.messagesGroupsViewController = [[MessagesGroupsViewController alloc] initWithNibName:@"MessagesGroupsViewController" bundle:nil];
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.messagesGroupsViewController.managedObjectContext = appDelegate.managedObjectContext;
    }
    //self.addReminderViewController.detailItem = nil;
    //self.addReminderViewController.delegateReminder = self;
    
    [self.navigationController pushViewController:self.messagesGroupsViewController animated:YES];
}

-(NSArray *)checkCourses
{
    NSArray *courses = [NSArray alloc];
 
    return courses;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.students count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)searchStudents
{

    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Student" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        //Error
    }else{
        if(!array.count)
        {
            
            
        }else{
            
            for(NSManagedObject* object in array){
                
                [self.students addObject:object];
            }
            
            [self.tableView reloadData];
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.students objectAtIndex:[indexPath row]];
    cell.textLabel.text = [[object valueForKey:@"name"] description];
    cell.detailTextLabel.text = [[object valueForKey:@"lastname"] description];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.messageInterfaceViewController)
    {
        self.messageInterfaceViewController = [[MessagesInterfaceViewController alloc] initWithNibName:@"MessagesInterfaceViewController" bundle:nil];
    }
    // Pass the selected object to the new view controller.
    self.messageInterfaceViewController.managedObjectContext = self.managedObjectContext;
    NSManagedObject *object = [self.students objectAtIndex:[indexPath row]];
    NSDictionary *student = [[NSDictionary alloc] initWithObjects: [[NSArray alloc] initWithObjects:[object valueForKey:@"id"],[object valueForKey:@"lastname"],[object valueForKey:@"name"], nil] forKeys:    [[NSArray alloc] initWithObjects:@"idAlumno",@"nombre",@"apellidos", nil]
];
    
   
    self.messageInterfaceViewController.student = student;
    
    // Push the view controller.
    [self.navigationController pushViewController:self.messageInterfaceViewController animated:YES];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Obteniendo nuevos mensajes..."];
 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Ultima actualización %@",
    [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}
@end
