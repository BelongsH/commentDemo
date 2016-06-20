//
//  CommentTableViewCell.m
//  CommontDemo
//
//  Created by 诺心ios on 16/5/26.
//  Copyright © 2016年 诺心ios. All rights reserved.
//

#import "CommentTableViewCell.h"

#define kNameFont [UIFont systemFontOfSize:15]
#define kShuoshuotextFont [UIFont systemFontOfSize:14]
#define kTimeFont [UIFont systemFontOfSize:11]
#define kReplytextFont [UIFont systemFontOfSize:14]

@interface CommentTableViewCell ()

/** 头像 */
@property (nonatomic, strong) UIImageView *iconImgV;
/** 昵称 */
@property (nonatomic, strong) UILabel *nameLbl;
/** 正文 */
@property (nonatomic, strong) UILabel *shuoshuoTextLbl;
/** 时间戳 */
@property (nonatomic, strong) UILabel *timeLbl;
/** 点赞按钮 */
@property (nonatomic, strong) UIButton *likeBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commentBtn;
/** 回复按钮 */
@property (nonatomic, strong) NSMutableArray *replysArr;

@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgV];
        
        self.nameLbl = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLbl];
        
        self.shuoshuoTextLbl = [[UILabel alloc] init];
        [self.contentView addSubview:_shuoshuoTextLbl];
        
        self.timeLbl = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLbl];
        
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_likeBtn];
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_commentBtn];
    }
    return self;
}

// 懒加载
- (NSMutableArray *)replysArr
{
    if (!_replysArr) {
        self.replysArr = [NSMutableArray array];
    }
    return _replysArr;
}

- (void)setCommentGroupFrame:(CommentGroupFrame *)commentGroupFrame
{
    _commentGroupFrame = commentGroupFrame;
    
    [self removeOldData];
    
    CommentGroupModel *model = commentGroupFrame.commentGroup;
    
    // 设置头像属性
    _iconImgV.image = [[UIImage imageNamed:model.icon] circleImage];
    //_iconImgV.layer.cornerRadius = commentGroupFrame.iconFrame.size.width / 2;
    
    // 设置昵称属性
    _nameLbl.text = model.name;
    _nameLbl.numberOfLines = 0;
    _nameLbl.textColor = [UIColor blueColor];
    _nameLbl.font = kNameFont;
    
    // 设置正文属性
    _shuoshuoTextLbl.text = model.shuoshuoText;
    _shuoshuoTextLbl.numberOfLines = 0;
    _shuoshuoTextLbl.textColor = [UIColor darkGrayColor];
    _shuoshuoTextLbl.font = kShuoshuotextFont;
    
    // 设置时间戳属性
    _timeLbl.text = model.time;
    _timeLbl.textColor = [UIColor grayColor];
    _timeLbl.font = kTimeFont;
    
    // 设置点赞按钮属性
    [_likeBtn setImage:[UIImage imageNamed:@"点赞1"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"点赞2"] forState:UIControlStateSelected];
    [_likeBtn setTitle:[NSString stringWithFormat:@"%@", model.likeCounts] forState:UIControlStateNormal];
    [_likeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置评论按钮属性
    [_commentBtn setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置回复视图属性
    for (NSInteger i = 0; i < model.replyArr.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = kReplytextFont;
        
        // 设置属性字符串
        NSString *text = model.replyArr[i];
        NSRange range = [text rangeOfString:@"([\u4e00-\u9fa5]|[a-zA-Z0-9])+：" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, range.length - 1)];
            label.attributedText = str;
        }
        
        // 设置回复文本大小
        label.frame = [self.commentGroupFrame.replysArray[i] CGRectValue];
        
        [self.replysArr addObject:label];
        [self.contentView addSubview:label];
    }
}

// 点赞按钮事件
- (void)likeBtnClick:(UIButton *)button
{
    self.likeBtnClick(button);
}

// 评论按钮事件
- (void)commentBtnClick:(UIButton *)button
{
    self.commentBtnClick(button);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置头像大小
    _iconImgV.frame = self.commentGroupFrame.iconFrame;
    
    // 设置昵称大小
    _nameLbl.frame = self.commentGroupFrame.nameFrame;
    
    // 设置正文大小
    _shuoshuoTextLbl.frame = self.commentGroupFrame.shuoshuoTextFrame;
    
    // 设置时间戳大小
    _timeLbl.frame = self.commentGroupFrame.timeFrame;
    
    // 设置点赞按钮大小
    _likeBtn.frame = self.commentGroupFrame.likeFrame;
    
    // 设置评论按钮大小
    _commentBtn.frame = self.commentGroupFrame.commentFrame;
}

// 防止重复
- (void)removeOldData
{
    for (UIView *view in self.replysArr) {
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
    [_replysArr removeAllObjects];
}

@end