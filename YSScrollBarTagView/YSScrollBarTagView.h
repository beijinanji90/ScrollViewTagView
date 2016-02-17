//
//  YSScrollBarTagView.h
//  YSScrollBarTagView
//
//  Created by chenfenglong on 16/2/17.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSScrollTagView.h"

//滚动时Block回调
typedef void(^ScrollBlock)(YSScrollTagView *tipBarView);

//通过Block传递视图
typedef YSScrollTagView *(^TagViewBlock)();

@interface YSScrollBarTagView : NSObject

//滚动视图
@property (nonatomic,weak) UITableView *scrollView;

//系统原始滚动条
@property (nonatomic,strong) UIView *originScrollBar;

//自定义滚动Tag
@property (nonatomic,weak) YSScrollTagView *newlyScrollTagView;

//滚动时Block
@property (nonatomic,copy) ScrollBlock didScrollBlock;

//开始初始化
- (void)initWithTableView:(UITableView *)tableView withTagView:(TagViewBlock)tagViewBlock didScrollBlock:(ScrollBlock)didScrollBlock;

@end
