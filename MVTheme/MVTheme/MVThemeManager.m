//
//  MVThemeManager.m
//  MVTheme
//
//  Created by Martin Yin on 7/13/2015.
//  Copyright (c) 2015 Marchell. All rights reserved.
//

#import "MVThemeManager.h"
#import "MVTheme.h"
#import "MVThemeDefines.h"

@interface MVThemeManager ()

@property (strong, nonatomic) MVTheme *defaultTheme;
@property (strong ,nonatomic) MVTheme *currentTheme;

@property (strong, nonatomic) NSMutableOrderedSet *searchPaths;

@property (strong, nonatomic) NSMutableArray      *allThemeNames;
@property (strong, nonatomic) NSMutableDictionary *allThemeDictionary;

@end

@implementation MVThemeManager

+ (instancetype)sharedManager {
    static MVThemeManager *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[MVThemeManager alloc] init];
    });
    
    return s_manager;
}

- (instancetype)init {
    self = [super init];
    
    self.defaultTheme = [MVTheme loadFromPath:[kMVThemeDefaultDirectory stringByAppendingPathComponent:kMVThemeDefaultThemePackage]];

    self.searchPaths = [NSMutableOrderedSet orderedSetWithObject:kMVThemeDefaultDirectory];
    self.allThemeNames = [NSMutableArray array];
    self.allThemeDictionary = [NSMutableDictionary dictionary];
    
    [self applyTheme:self.defaultTheme];
    
    return self;
}

+ (MVTheme *)theme {
    return [[self sharedManager] currentTheme];
}

- (MVTheme *)currentTheme {
    return _currentTheme;
}

- (void)addThemeToList:(MVTheme *)theme {
    if(!theme)
        return;

    if(![self.allThemeNames containsObject:theme.name]) {
        [self.allThemeNames addObject:theme.name];
    }
    [self.allThemeDictionary setObject:theme forKey:theme.name];
}

- (void)applyTheme:(MVTheme *)theme {
    self.currentTheme = theme;
    
    [self addThemeToList:theme];
}

- (void)applyThemeWithThemePath:(NSString *)themePath {
    [self applyTheme:[MVTheme loadFromPath:themePath]];
}

- (MVTheme *)themeWithName:(NSString *)themeName {
    return self.allThemeDictionary[themeName];
}

- (NSString *)removeEnddingSlash:(NSString *)path {
    while ([path hasSuffix:@"/"]) {
        path = [path substringToIndex:path.length-1];
    }
    
    return path;
}

- (void)addThemeSearchPath:(NSString *)searchPath {
    [self.searchPaths addObject:[self removeEnddingSlash:searchPath]];
}

- (void)deleteThemeSearchPath:(NSString *)searchPath {
    [self.searchPaths removeObject:[self removeEnddingSlash:searchPath]];
}

- (NSArray *)allSearchPaths {
    return self.allSearchPaths;
}

- (void)searchAllThemes {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(NSString *path in self.searchPaths) {
        NSArray *subpaths = [fileManager subpathsOfDirectoryAtPath:path error:nil];
        NSIndexSet *indexSet = [subpaths indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [[obj lastPathComponent] isEqualToString:kMVThemePlistFileName];
        }];
        subpaths = [subpaths objectsAtIndexes:indexSet];
        
        for(NSString *themePath in subpaths) {
            [self addThemeToList:[MVTheme loadFromPath:[themePath stringByDeletingLastPathComponent]]];
        }
    }
}

- (NSArray *)allThemes {
    NSArray *themes = [_allThemeDictionary objectsForKeys:self.allThemeNames notFoundMarker:@""];
    return [themes objectsAtIndexes:[themes indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:[MVTheme class]];
    }]];
}

+ (UIFont *)fontWithName:(NSString *)fontKey {
    return [[self theme] fontWithName:fontKey];
}

+ (UIColor *)colorWithName:(NSString *)colorKey {
    return [[self theme] colorWithName:colorKey];
    
}

+ (UIImage *)imageWithName:(NSString *)imageKey {
    return [[self theme] imageWithName:imageKey];
    
}

@end
