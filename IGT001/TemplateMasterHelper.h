//
//  TemplateMasterHelper.h
//  IGT001
//
//  Created by DATA NTT on 12/05/08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TemplateMaster.h"

@interface TemplateMaster (TemplateMasterHelper)
- (void)addItemsObject:(ItemMaster *)value;
- (void)removeItemsObject:(ItemMaster *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
