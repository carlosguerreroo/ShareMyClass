//
//  Reminder.h
//  ShareMyClass
//
//  Created by carlos omana on 28/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *message;
@property (nonatomic)BOOL check;
@property (nonatomic, strong)NSDate *date;

@end
