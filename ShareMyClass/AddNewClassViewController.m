//
//  AddNewClassViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/3/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "AddNewClassViewController.h"
#import "HelperMethods.h"

@interface AddNewClassViewController ()

@property(strong, nonatomic)NSMutableData *receivedData;

@end

@implementation AddNewClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 Nombre: viewDidLoad
 Uso: Método que se llama cuando se carga la vista
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Agregar clase";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewClass:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Estas a punto de crear y suscribirte al curso de:" message:[NSString stringWithFormat:@"%@",self.className.text] delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Aceptar",nil];
    
    [alert show];
    
}


- (IBAction)hideKeyboard:(id)sender
{
    [self.className resignFirstResponder];
    [self.classId resignFirstResponder];

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
	NSString *infoRecibidaString = [[NSString alloc] initWithData: self.receivedData
                                                         encoding:NSUTF8StringEncoding];
    
    if([infoRecibidaString  integerValue])
    {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self inserNewCourseWithCourseId:[NSNumber numberWithInteger:[infoRecibidaString  integerValue]] realCourseid:self.classId.text andName:self.className.text];
    }
    infoRecibidaString = nil;
    self.receivedData = nil;
}


-(void)registerClass{
   
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
    
    NSString *className = [[NSString alloc]initWithString:self.className.text];
    NSString *classId = [[NSString alloc]initWithString:self.classId.text];

    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=newcourse&nombreCurso=%@&idCursoReal=%@&idAlumno=%@",className,classId,studentId];
    //NSLog(@" la llamada al web service %@ ", paramDataString);
    
    NSData * paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:paramData];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (theConnection)
    {
        self.receivedData = [[NSMutableData alloc] init];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"No se pudo enlazar con el servicio web!"
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self registerClass];

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
