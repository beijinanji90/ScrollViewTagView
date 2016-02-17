//
//  ViewController.m
//  YSScrollBarTagView
//
//  Created by chenfenglong on 16/2/17.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "ViewController.h"
#import "YSScrollBarTagView.h"




/*
 三个方面注意：
    1、在使用initWithTableView: withTagView: didScrollBlcok:的时候需要把在UITabelView添加子控件之前使用，
    因为在代码中需要使用tableView.subviews.lastObject获取滚动视图最原始的滚动条。
    2、自定义的滚动条在消失的瞬间，在滚动的时候，有出不来的情况，浮现率很低（暂不修改）。
    3、滚动视图必须是UITableView，否则过不了NSAssert断言。
 */



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTable];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setTable
{
    // Do any additional setup after loading the view, typically from a nib.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.showsHorizontalScrollIndicator = YES;
    tableView.scrollEnabled = YES;
    tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak typeof(self) _weakSelf = self;
    [[YSScrollBarTagView alloc] initWithTableView:self.tableView withTagView:^YSScrollTagView *{
        YSScrollTagView *tagView = [[YSScrollTagView alloc] init];
        return tagView;
    
    } didScrollBlock:^(YSScrollTagView *tipBarView) {
        //设置提示的文字
        NSArray *visableCell = _weakSelf.tableView.visibleCells;
        for (UITableViewCell *cell in visableCell) {
            if (CGRectContainsPoint(cell.frame, tipBarView.center)) {
                tipBarView.tipContent = [NSString stringWithFormat:@"%tdkm", [self.tableView indexPathForCell:cell].row];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

@end
