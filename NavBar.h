//
//  NavBar.h
//  Imprint
//
//  Created by Geoff Baker on 19/09/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavBar : NSObject

-(NSArray *)getSideBarTitles;
-(NSArray *)getTitles;
-(NSArray *)getXPositions:(int)height;
-(int)getSize;
-(NSArray *)getControllerLinks;
-(NSMutableArray *)getActiveViewsPositions:(int)height;
-(NSArray *)getButtonWidth:(int)height;
-(NSMutableArray *)getContentOffset:(int)height;
@end
