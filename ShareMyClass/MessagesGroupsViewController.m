//
//  MessagesGroupsViewController.m
//  ShareMyClass
//
//  Created by carlos omana on 03/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MessagesGroupsViewController.h"
#define userDataPlist @"user.plist"

@interface MessagesGroupsViewController ()

//@property (strong, nonatomic)

@end

@implementation MessagesGroupsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Seleccion el curso";
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*NSString *filePath = [self dataFilePath];
    
    if(self.managedObjectContext == nil)
    {
        NSLog(@"Es null");
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        [self getCourses:[dataDictionary objectForKey:@"id"]];
        
    }
    
    for(NSManagedObject *object in  [self.fetchedResultsController fetchedObjects])
    {
        
        NSLog(@"%@",[[object valueForKey:@"courseId"] description]);
        
        
    }*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)getCourses:(NSString *)userId
{
    
    //URL a usar para mandar los parametros
    NSURL *url = [NSURL URLWithString:@"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:60];
        
    [req setHTTPMethod:@"POST"];	//indicamos que es un metodo POST
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //Indicamos en que formato esta lo que mandamos
        
    //Valor del post
    NSString *postData = [NSString stringWithFormat:@"cmd=getcourses&idAlumno=%@",userId]; //Mandamos el valor
        
    NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
    [req setValue:length forHTTPHeaderField:@"Content-Length"];   //indicamos en nuestro paquete el tamaño de
        
    [req setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]]; //Mandamos el contenido de este
        
    NSHTTPURLResponse* urlResponse = nil;     //Vemos nuestra respuesta
    NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
        
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req
                                                     returningResponse:&urlResponse
                                                                 error:&error];
    
    
    NSArray *jsonCourses = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    //NSLog(@"Respueta: %@ %@ %@", [jsonCourses[0]  objectForKey:@"idCurso"], [jsonCourses[0]  objectForKey:@"idCursoReal"],[jsonCourses[0]  objectForKey:@"nombreCurso"]); //imprimimos lo obtenido
    
    for (NSDictionary *course in jsonCourses)
    {
    
        //NSLog(@"%@",[course objectForKey:@"idCursoReal"]);
        //[self inserNewCourseWithCourseId: [NSNumber numberWithInteger: [[course objectForKey:@"idCurso"] intValue]] realCourseid:[course objectForKey:@"idCursoReal"] andName:[course objectForKey:@"nombreCurso"]];
    }
    // ;
//[[object valueForKey:@"courseName"] description]
    
   

}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (!self.messagesStudentsViewController)
   {
        self.messagesStudentsViewController = [[MessagesStudentsViewController alloc] initWithNibName:@"MessagesStudentsViewController" bundle:nil];
   }
    self.messagesStudentsViewController.selectedCourse = [[self fetchedResultsController] objectAtIndexPath:indexPath];
   // NSLog([self.messagesStudentsViewController ] )
    //.selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    // self.addReminderViewController.detailItem = self.selectedObject;
   [self.navigationController pushViewController:self.messagesStudentsViewController animated:YES];
}

#pragma mark - Data Methods

-(NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:userDataPlist];
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"courseName"] description];
    cell.detailTextLabel.text = [[object valueForKey:@"realCourseId"] description];
    

}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Courses" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"courseId" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
