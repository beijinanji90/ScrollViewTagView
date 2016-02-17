//
//  YSScrollBarTagView.m
//  YSScrollBarTagView
//
//  Created by chenfenglong on 16/2/17.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "YSScrollBarTagView.h"
#import <objc/runtime.h>

@interface YSScrollBarTagView ()

//正在动画显示
@property (nonatomic,assign) BOOL isAnimationShow;

//正在动画消失
@property (nonatomic,assign) BOOL isAnimationHide;

@end

@implementation YSScrollBarTagView

- (void)dealloc
{
    [self.originScrollBar removeObserver:self forKeyPath:@"frame"];
    [self.originScrollBar removeObserver:self forKeyPath:@"alpha"];
}

- (void)initWithTableView:(UITableView *)tableView withTagView:(TagViewBlock)tagViewBlock didScrollBlock:(ScrollBlock)didScrollBlock
{
    //判断滚动视图的类型
    NSAssert([tableView isKindOfClass:[UITableView class]], @"Is not UITableView");
    
    //防止重复添加
    if (!objc_getAssociatedObject(tableView, @selector(initWithTableView:withTagView:didScrollBlock:))) {
        
        YSScrollBarTagView *scrollBarTagView = [[YSScrollBarTagView alloc] init];
        scrollBarTagView.scrollView = tableView;
        scrollBarTagView.originScrollBar = tableView.subviews.lastObject;
        scrollBarTagView.didScrollBlock = didScrollBlock;
        //tag的视图
        YSScrollTagView *tipBarView = tagViewBlock();
        tipBarView.alpha = 0.0;
        scrollBarTagView.newlyScrollTagView = tipBarView;
        
        //开始监视滚动的位置、透明度的变化
        [scrollBarTagView.originScrollBar addObserver:scrollBarTagView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [scrollBarTagView.originScrollBar addObserver:scrollBarTagView forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
        
        //添加tag
        CGFloat scrollTagW = 66;
        CGFloat scrollTagX = tableView.frame.size.width - 15 - scrollTagW;
        CGFloat scrollTagH = 20;
        scrollBarTagView.newlyScrollTagView.frame = CGRectMake(scrollTagX, 0, scrollTagW, scrollTagH);
        [tableView addSubview:scrollBarTagView.newlyScrollTagView];
        objc_setAssociatedObject(tableView, _cmd, scrollBarTagView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        
        //系统默认的滚动条
        UIView *originScrollBar = self.originScrollBar;
        
        //新加的提示View
        YSScrollTagView *newScrollBar = self.newlyScrollTagView;
        newScrollBar.center = CGPointMake(newScrollBar.center.x, originScrollBar.center.y);
        
        //Block回调
        self.didScrollBlock(self.newlyScrollTagView);
    }
    else if ([keyPath isEqualToString:@"alpha"])
    {
        //系统默认的滚动条
        UIView *originScrollBar = self.originScrollBar;
        
        //新加的提示View
        YSScrollTagView *newScrollBar = self.newlyScrollTagView;
        
        /*
         需要显示的时候分为两种：
         origin.alpha != 0 new.alpha == 0 self.isAnimationHide == NO
         origin.alpha != 0 new.alpha != 0 self.isAnimationHide == YES
         */
        if (self.isAnimationHide == NO && originScrollBar.alpha != 0 && newScrollBar.alpha == 0)
        {
            if (self.isAnimationShow == YES) {
                return;
            }
            
            self.isAnimationShow = YES;
            [UIView animateWithDuration:.3 animations:^{
                newScrollBar.transform = CGAffineTransformIdentity;
                newScrollBar.alpha = 1.0;
            } completion:^(BOOL finished) {
                self.isAnimationShow = NO;
            }];
        }
        else if (self.isAnimationHide == YES && originScrollBar.alpha != 0 && newScrollBar.alpha != 0)
        {
            [newScrollBar.layer removeAllAnimations];
            
            self.isAnimationShow = YES;
            [UIView animateWithDuration:.3 animations:^{
                newScrollBar.transform = CGAffineTransformIdentity;
                newScrollBar.alpha = 1.0;
            } completion:^(BOOL finished) {
                self.isAnimationShow = NO;
            }];
        }
        
        //隐藏可以单独拿出来
        if (originScrollBar.alpha == 0)
        {
            if (self.isAnimationHide == YES) {
                return;
            }
            if (self.isAnimationShow == YES) {
                [newScrollBar.layer removeAllAnimations];
            }
            
            self.isAnimationHide = YES;
            [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                CGAffineTransform transform1 = CGAffineTransformMakeTranslation(newScrollBar.frame.size.width, 0);
                newScrollBar.transform = transform1;
            } completion:^(BOOL finished) {
                newScrollBar.alpha = 0.0;
                self.isAnimationHide = NO;
            }];
        }
    }
}


@end
