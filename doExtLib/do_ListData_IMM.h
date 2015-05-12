//
//  do_ListData_MM.h
//  DoExt_MM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol do_ListData_IMM <NSObject>
//实现同步或异步方法，parms中包含了所需用的属性
@required
- (void)addData:(NSArray *)parms;
- (void)addOne:(NSArray *)parms;
- (void)getCount:(NSArray *)parms;
- (void)getData:(NSArray *)parms;
- (void)getOne:(NSArray *)parms;
- (void)getRange:(NSArray *)parms;
- (void)removeAll:(NSArray *)parms;
- (void)removeData:(NSArray *)parms;
- (void)removeOne:(NSArray *)parms;
- (void)removeRange:(NSArray *)parms;
- (void)updateOne:(NSArray *)parms;

@end