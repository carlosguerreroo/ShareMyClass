//
//  AppDelegate.m
//  ShareMyClass
//
//  Created by carlos omana on 07/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "loginViewController.h"
#define userDataPlist @"user.plist"

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) ViewController *mainViewController;
@property (strong, nonatomic) NSMutableData *receivedData;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

/*
Nombre: application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
Uso: Se ejecuta cuando se carga la aplicaciín para iniciar opciones
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.mainViewController.managedObjectContext = [self managedObjectContext];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSession];
    } else {
        [self showLoginView];
    }
    return YES;
}
/*
 Nombre: showLoginView
 Uso: Muesta la pantalla de login
 */
- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController presentedViewController];
    

    if (![modalViewController isKindOfClass:[loginViewController class]]) {
        loginViewController* loginViewControllerVar = [[loginViewController alloc]
                                                      initWithNibName:@"loginViewController"
                                                      bundle:nil];
        [topViewController presentViewController:loginViewControllerVar animated:NO completion:nil];
    } else {
        loginViewController* loginViewControllerVar = (loginViewController*)modalViewController;
        [loginViewControllerVar loginFailed];
    }
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
 
    [self saveContext];

}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {

            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/*
 Nombre: sessionStateChanged
 Uso: Cuando hay un cambio de estado de la sesion de facebook se llama
 */

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
            
            UIViewController *topViewController = [self.navController topViewController];
			if ([[topViewController presentedViewController] isKindOfClass:[loginViewController class]]) {

                
                [FBRequestConnection
                 startWithGraphPath:@"me?fields=id,first_name,last_name"
                 completionHandler:^(FBRequestConnection *connection,
                                     id result,
                                     NSError *error) {
                     if (!error)
                     {
                         [self registerUser:result];
                         [self writeUserData:result];
                         [topViewController dismissViewControllerAnimated:NO completion:Nil];
                         
                     }
                 }];
            
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:

            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
/*
 Nombre: openSession
 Uso: Funcion para iniciar la session con facebook
 */
- (void)openSession
{
    
    NSArray *permission = [[NSArray alloc] initWithObjects:@"email", nil];
    FBSession *sessions = [[FBSession alloc] initWithPermissions:permission];
    [FBSession setActiveSession:sessions];
    [sessions openWithBehavior:FBSessionLoginBehaviorForcingWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                NSLog(@"%@",[session accessTokenData]);
                [self sessionStateChanged:session state:status error:error];
            }];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShareMyClassData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShareMyClassData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
       
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


/*
 Nombre: registerUser
 Uso: Funcion para agregar al usuario a la base de datos
 */

-(void)registerUser:(id)userData
{
    
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [request setHTTPMethod:@"POST"];
    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=join&idAlumno=%@&nombre=%@&apellidos=%@",[userData objectForKey:@"id"], [userData objectForKey:@"first_name"],[userData objectForKey:@"last_name"]]; //Mandamos el valor

    
    //NSLog(@" la llamada al web service %@ ", paramDataString);
    
    NSData * paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paramData];
    
    NSURLConnection *registerConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (registerConnection)
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

/*
 Nombre: writeUserData
 Uso: Guarda la información del usuario en un diccionario
 */

-(BOOL)writeUserData:(id)userData
{
    NSDictionary *userDataDictionary = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects: [userData objectForKey:@"id"],[userData objectForKey:@"first_name"],[userData objectForKey:@"last_name"], nil] forKeys:[[NSArray alloc] initWithObjects: @"id", @"first_name", @"last_name", nil]];
    
    NSLog(@"%@",userDataDictionary);
    
    [userDataDictionary writeToFile:[self dataFilePath] atomically:YES];
    return true;
    
}

/*
 Nombre: dataFilePath
 Uso: funcion del path del diccionario
 */

-(NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:userDataPlist];
    
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

/*
 Nombre: connectionDidFinishLoading
 Uso: función que se ejecuta después de la llamada a la base de datos
 */


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *infoRecibidaString = [[NSString alloc] initWithData: self.receivedData
                                                         encoding:NSUTF8StringEncoding];
    
    NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
    NSArray *jsonCourses = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
    
    for(NSDictionary *course in jsonCourses)
    {
      
        
        [self inserNewCourseWithCourseId: [NSNumber numberWithInteger: [[course objectForKey:@"idCurso"] integerValue]] realCourseid:[course objectForKey:@"idCursoReal"] andName:[course objectForKey:@"nombreCurso"]];
    }
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    self.mainViewController.fetchedResultsController = nil;

    [self.mainViewController.collectionView reloadData];

    infoRecibidaString = nil;
    self.receivedData = nil;
}

/*
 Nombre: inserNewCourseWithCourseId
 Uso: función que agrega un curso a la entidad
 */

-(void)inserNewCourseWithCourseId:(NSNumber*)courseId realCourseid:(NSString*) realCourseId andName:(NSString*)name
{
   
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *courseObject = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Courses"
                                        inManagedObjectContext:context];
        
    [courseObject setValue: courseId  forKey:@"courseId"];
    [courseObject setValue: realCourseId forKey:@"realCourseId"];
    [courseObject setValue: name forKey:@"courseName"];
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


@end
