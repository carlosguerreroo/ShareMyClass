//
//  NewClassViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "NewClassViewController.h"
#import "AddNewClassViewController.h"
#import "HelperMethods.h"
#import "AppDelegate.h"

@interface NewClassViewController ()

@property (nonatomic, strong) NSMutableData* receivedData;
@property (nonatomic, strong) NSArray* courses;
@property (nonatomic, strong) NSArray* searchResults;
@property (nonatomic, strong) NSDictionary *selectedCourse;

-(void)remainingCourses;
-(void)joinToCourse;

@end

@implementation NewClassViewController

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
    // Do any additional setup after loading the view from its nib.
	self.title = @"Nueva clase";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(newClass)]];
    [self remainingCourses];
 
}
-(void)newClass
{
    if(!self.addNewClassViewController){
        self.addNewClassViewController = [[AddNewClassViewController alloc] initWithNibName:@"AddNewClassViewController" bundle:nil];
    }
    
    self.addNewClassViewController.className.text = @"";
    self.addNewClassViewController.classId.text = @"";
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.addNewClassViewController.managedObjectContext = appDelegate.managedObjectContext;
    [self.navigationController pushViewController:self.addNewClassViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLConnection
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse * )response
{
	[self.receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receivedData = nil;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:[NSString stringWithFormat:
                                                              @"No se pudo crear la conexión - %@",
                                                              [error localizedDescription]]
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *body = [[[NSString alloc] initWithData: connection.originalRequest.HTTPBody
                                                         encoding:NSUTF8StringEncoding] substringToIndex:23];
   
    if([body isEqualToString:@"cmd=getremainingcourses"])
    {
        NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
        NSArray *jsonCourses = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
        self.courses = jsonCourses;
        [self.tableView reloadData];
        self.receivedData = nil;
        
    }else{
        
        if([[[NSString alloc ]initWithData: self.receivedData encoding:NSUTF8StringEncoding] isEqualToString:@"YES"])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self inserNewCourseWithCourseId:[NSNumber numberWithInteger:[[self.selectedCourse objectForKey:@"idCurso"] integerValue]]
                                realCourseid:[self.selectedCourse objectForKey:@"idCursoReal"]
                                     andName:[self.selectedCourse objectForKey:@"nombreCurso"]];
        }
        
        self.receivedData = nil;
        [self remainingCourses];
    }
    
}


-(void)remainingCourses
{
    
    NSLog(@"remainingCourses");
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    NSString *filePath = [[HelperMethods alloc] dataFilePath];
    NSString *studentId;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        studentId = [[NSString alloc]initWithString:[dataDictionary objectForKey:@"id"]];
    }

    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=getremainingcourses&idAlumno=%@", studentId];
    //NSLog(@" la llamada al web service %@ ", paramDataString);
    
    NSData * paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:paramData];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (theConnection)
    {
        self.receivedData = [[NSMutableData alloc] init];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"No se pudo enlazar con el servicio web!"
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        [alert show];
    }
}

-(void)joinToCourse
{
    
    NSLog(@"joinToCourse");
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    NSString *filePath = [[HelperMethods alloc] dataFilePath];
    NSString *studentId;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        studentId = [[NSString alloc]initWithString:[dataDictionary objectForKey:@"id"]];
    }
    
    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=joincourse&idAlumno=%@&idCurso=%@", studentId,[self.selectedCourse objectForKey:@"idCurso"]];
    //NSLog(@" la llamada al web service %@ ", paramDataString);
    
    NSData * paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:paramData];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (theConnection)
    {
        self.receivedData = [[NSMutableData alloc] init];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"No se pudo enlazar con el servicio web!"
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        [alert show];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
        
    } else {
        return [self.courses count];
        
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *idCell = @"idCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"nombreCurso"];
    }
    else
    {
        NSInteger row = [indexPath row];
        NSDictionary *course = [self.courses objectAtIndex:row];
        cell.detailTextLabel.text = [course objectForKey:@"idCursoReal"];
        cell.textLabel.text = [course objectForKey:@"nombreCurso"];
    }
    

  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Estas a punto de suscribirte al curso de:" message:[NSString stringWithFormat:@"%@",[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]] delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Aceptar",nil];
    
    //self.selectedCourse = [[[self.courses objectAtIndex:[indexPath row]] objectForKey:@"idCurso"] integerValue];
    self.selectedCourse =  [self.courses objectAtIndex:[indexPath row]];

    [alert show];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.nombreCurso contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.courses filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        //NSLog(@"Register User");
        [self joinToCourse];
    }
}
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

-(void)inserNewCourseWithCourseId:(NSNumber*)courseId realCourseid:(NSString*) realCourseId andName:(NSString*)name{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue: courseId  forKey:@"courseId"];
    [newManagedObject setValue: realCourseId forKey:@"realCourseId"];
    [newManagedObject setValue: name forKey:@"courseName"];
    NSLog(@"%@%@%@",courseId, realCourseId,name);
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


@end
