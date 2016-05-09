//
//  MVTheme.m
//  MVTheme
//
//  Created by Martin Yin on 7/13/2015.
//  Copyright (c) 2015 Marchell. All rights reserved.
//

#import "MVTheme.h"
#import "MVThemeDefines.h"
#import "MVThemeManager.h"

@interface MVTheme ()

@property (strong ,nonatomic) NSString *themePath;
@property (strong, nonatomic) MVTheme  *baseTheme;
@property (strong, nonatomic) NSString *baseThemeName;

@end

@implementation MVTheme

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (instancetype)initWithPath:(NSString *)themePath {
    self = [self init];

    NSDictionary *fileContent = [NSDictionary dictionaryWithContentsOfFile:[themePath stringByAppendingPathComponent:kMVThemePlistFileName]];
    self.name = fileContent[kMVThemePropertyNameKey];
    self.baseThemeName = fileContent[kMVThemeBaseThemeKey];
    self.items = fileContent[kMVThemePropertyItemsKey];
    
    self.baseTheme = nil;
    
    self.themePath = themePath;
    
    return self;
}

+ (instancetype)loadFromPath:(NSString *)themePath {
    return [[self alloc] initWithPath:themePath];
}

- (MVTheme *)baseTheme {
    if(_baseThemeName && !_baseTheme) {
        _baseTheme = [[MVThemeManager sharedManager] themeWithName:self.baseThemeName];
    }
    
    return _baseTheme;
}

- (UIFont *)fontWithName:(NSString *)fontKey {
    NSString *fontValue = [self propertyWithName:fontKey];
    UIFont *font = nil;
    NSArray *fontComponents = [fontValue componentsSeparatedByString:@","];
    if([fontComponents count] == 2) {
        NSString *fontName = fontComponents[0];
        CGFloat fontSize = [fontComponents[1] floatValue];
        if([[fontName lowercaseString] isEqualToString:@"bold"]) {
            font = [UIFont boldSystemFontOfSize:fontSize];
        } else if([[fontName lowercaseString] isEqualToString:@"italic"]) {
            font = [UIFont italicSystemFontOfSize:fontSize];
        } else if([[fontName lowercaseString] isEqualToString:@"normal"] || [[fontName lowercaseString] isEqualToString:@"system"]) {
            font = [UIFont systemFontOfSize:fontSize];
        } else {
            font = [UIFont fontWithName:fontName size:fontSize];
        }
        if(!font) {
            font = [UIFont systemFontOfSize:fontSize];
        }
    }
    
    if(!font && fontValue) {
        font = [self.baseTheme fontWithName:fontValue];
    }

    return font;
}

- (UIColor *)colorWithName:(NSString *)colorKey {
    NSString *colorValue = [self propertyWithName:colorKey];
    UIColor *color = nil;
    if([colorValue hasPrefix:@"#"]) {
        NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
        NSString *hexString = colorComponents[0];
        CGFloat alpha = (colorComponents.count == 2)?[colorComponents[1] floatValue]:1.0f;
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];

        int red   = (rgbValue & 0xFF0000) >> 16;
        int green = (rgbValue & 0x00FF00) >> 8;
        int blue  = (rgbValue & 0x0000FF);
        
        color = [UIColor colorWithRed:(float)red/255.0f green:(float)green/255.0f blue:(float)blue/255.0f alpha:alpha];
    } else {
        NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
        if([colorComponents count] == 3 || [colorComponents count] == 4) {
            color = [UIColor colorWithRed:[colorComponents[0] floatValue]/255.0f
                                    green:[colorComponents[1] floatValue]/255.0f
                                     blue:[colorComponents[2] floatValue]/255.0f
                                    alpha:(colorComponents.count == 3)?1.0f:[colorComponents[3] floatValue]/255.0f];
        }
    }
    
    if(!color && colorValue) {
        color = [self.baseTheme colorWithName:colorValue];
    }
    
    return color;
}

- (UIImage *)imageWithName:(NSString *)imageKey {
    NSString *imageValue = [self propertyWithName:imageKey];
    UIImage *image = nil;
    
    NSString *imagePath = [self.themePath stringByAppendingPathComponent:imageValue];
    image = [UIImage imageWithContentsOfFile:imagePath];

    if(!image && imageValue) {
        image = [self.baseTheme imageWithName:imageValue];
    }
    
    return image;
}

- (id)propertyWithName:(NSString *)key {
    id property = self.items[key];
    while([self.items objectForKey:property]) {
        property = self.items[property];
    }
    
    if(!property) {
        property = [self.baseTheme propertyWithName:key];
    }
    
    return property;
}

@end
