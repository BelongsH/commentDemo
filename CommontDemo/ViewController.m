//
//  ViewController.m
//  CommontDemo
//
//  Created by 诺心ios on 16/5/26.
//  Copyright © 2016年 诺心ios. All rights reserved.
//

#import "ViewController.h"
#import "CommentTableViewCell.h"
#import "replyViewController.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/** 评论数组 */
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation ViewController

#pragma mark - 懒加载 -
- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
        
        // 加载数据
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FamilyGroup.plist" ofType:nil];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *modelDic in dataArray) {
            CommentGroupModel *model = [[CommentGroupModel alloc] init];
            [model setValuesForKeysWithDictionary:modelDic];
            
            CommentGroupFrame *commentGroupFrame = [[CommentGroupFrame alloc] init];
            commentGroupFrame.commentGroup = model;
            
            [_commentArray addObject:commentGroupFrame];
        }
    }
    return _commentArray;
}

#pragma mark - 视图加载 -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

// 设置TableView
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    [_tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    [self.view addSubview:_tableView];
}

#pragma mark - TableView DataSrouce & Delegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentGroupFrame *frame = self.commentArray[indexPath.row];
    return frame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    CommentGroupFrame *commentGroupFrame = self.commentArray[indexPath.row];
    cell.commentGroupFrame = commentGroupFrame;
    
    // 点赞按钮点击回调
    cell.likeBtnClick = ^(UIButton *button) {
        // 获取点赞数量
        NSNumber *number = commentGroupFrame.commentGroup.likeCounts;
        NSInteger num = [number integerValue];
        
        // 判断按钮状态
        button.selected ? num-- : num++;
        button.selected = !button.selected;
        
        // 改变点赞数量
        number = [NSNumber numberWithInteger:num];
        commentGroupFrame.commentGroup.likeCounts = number;
        [button setTitle:[NSString stringWithFormat:@"%@", number] forState:UIControlStateNormal];
    };
    
    // 评论按钮点击回调
    cell.commentBtnClick = ^(UIButton *button) {
        replyViewController *replyVC = [[replyViewController alloc] init];
        
        // 刷新视图以显示回复
        replyVC.reloadTableView = ^(NSString *text) {
            [commentGroupFrame addNewReply:text];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        [self presentViewController:replyVC animated:YES completion:nil];
    };
    
    return cell;
}

@end