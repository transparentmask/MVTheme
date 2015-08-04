//
//  MVTheme.h
//  MVTheme
//
//  Created by Martin Yin on 7/13/2015.
//  Copyright (c) 2015 Marchell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVTheme : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *items;

+ (instancetype)loadFromPath:(NSString *)themePath;

- (MVTheme *)baseTheme;

- (UIFont *)fontWithName:(NSString *)fontKey;
- (UIColor *)colorWithName:(NSString *)colorKey;
- (UIImage *)imageWithName:(NSString *)imageKey;

- (id)propertyWithName:(NSString *)key;

@end
