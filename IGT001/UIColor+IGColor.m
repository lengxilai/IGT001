//
//  UIColor+IGColor.m
//  IGT001
//
//  Created by Ming Liu on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+IGColor.h"

@implementation UIColor (IGColor)
+(UIColor*)textPlanTopPanelColor
{
    return [UIColor blackColor];
}
+(UIColor*)textRedBlackColor
{
    return [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
}
+(UIColor*)textGrayColor
{
    return [UIColor grayColor];
}
+(UIColor*)textWhiteColor
{
    return [UIColor whiteColor];
}
+(UIColor*)viewBackgroundImageColor{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbak.png"]];
}
+(UIColor*)topPanelBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"toppanelbak.png"]];
}
+(UIColor*)checklistBackroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"checklistheaderbak.png"]];
}
+(UIColor*)checklistLineBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"checklistlinebak.png"]];
}
+(UIColor*)checklistFooterBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"checklistfooterbak.png"]];
}

+(UIColor*)planlistBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"planlistlinebak.png"]];
}

+(UIColor*)planlistHeaderBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"planlistheadbak.png"]];
}
+(UIColor*)planlistFooterBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"planlistfootbak.png"]];
}
+(UIColor*)classlistForCellBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"classlistforcellbck.png"]];
}
+(UIColor*)classlistForSectionBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"classlistforsectionbck.png"]];
}
+(UIColor*)classlistForInputBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"classlistforinputback.png"]];
}
+(UIColor*)templatelistBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"templatelistlinebak2.png"]];
}
+(UIColor*)setAlarmBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"setalarmbak.png"]];
}
+(UIColor*)setAlertTimeBackgroundImageColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"setalerttime.png"]];
}
@end
