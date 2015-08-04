//
//  MVThemeManager.h
//  MVTheme
//
//  Created by Martin Yin on 7/13/2015.
//  Copyright (c) 2015 Marchell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVTheme;
@interface MVThemeManager : NSObject

+ (instancetype)sharedManager;

// Short for current theme
+ (MVTheme *)theme;

// Return current using theme;
- (MVTheme *)currentTheme;

// Set current theme
- (void)applyTheme:(MVTheme *)theme;
- (void)applyThemeWithThemePath:(NSString *)themePath;

- (MVTheme *)themeWithName:(NSString *)themeName;

// Theme list
// Manager will search in all path added recursively
- (void)addThemeSearchPath:(NSString *)searchPath;
- (void)deleteThemeSearchPath:(NSString *)searchPath;
- (NSArray *)allSearchPaths;
- (void)searchAllThemes;
- (NSArray *)allThemes;

// Current properties quick access
+ (UIFont *)fontWithName:(NSString *)fontKey;
+ (UIColor *)colorWithName:(NSString *)colorKey;
+ (UIImage *)imageWithName:(NSString *)imageKey;


@end
