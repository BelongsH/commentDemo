//
//  CommentGroupFrame.m
//  CommontDemo
//
//  Created by 诺心ios on 16/5/26.
//  Copyright © 2016年 诺心ios. All rights reserved.
//

#import "CommentGroupFrame.h"

@implementation CommentGroupFrame

// 懒加载
- (NSMutableArray *)replysArray
{
    if (!_replysArray) {
        self.replysArray = [NSMutableArray array];
    }
    
    return _replysArray;
}

// 重写 setter
- (void)setCommentGroup:(CommentGroupModel *)commentGroup
{
    _commentGroup = commentGroup;
    
    // 头像大小计算
    CGFloat iconX = kPadding;
    CGFloat iconY = kPadding;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 昵称大小计算
    CGFloat nameX = CGRectGetMaxX(_iconFrame) + kPadding;
    CGFloat nameY = kPadding;
    CGSize nameSize = [self sizeWithFont:kNameFont withString:self.commentGroup.name];
    CGFloat nameW = nameSize.width;
    CGFloat nameH = nameSize.height;
    _nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    // 正文大小计算
    CGFloat shuoshuoTextX = nameX;
    CGFloat shuoshuoTextY = CGRectGetMaxY(_nameFrame) + kPadding;
    CGSize shuoshuoTextSize = [self sizeWithFont:kShuoshuotextFont withString:self.commentGroup.shuoshuoText];
    CGFloat shuoshuoTextW = shuoshuoTextSize.width;
    CGFloat shuoshuoTextH = shuoshuoTextSize.height;
    _shuoshuoTextFrame = CGRectMake(shuoshuoTextX, shuoshuoTextY, shuoshuoTextW, shuoshuoTextH);
    
    // 时间戳大小计算
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_shuoshuoTextFrame) + kPadding;
    CGFloat timeW = 50;
    CGFloat timeH = 15;
    _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    // 评论按钮大小计算
    CGFloat commentX = SCREENW - 35 - kPadding;
    CGFloat commentY = timeY;
    CGFloat commentW = 35;
    CGFloat commentH = 25;
    _commentFrame = CGRectMake(commentX, commentY, commentW, commentH);
    
    // 点赞按钮大小计算
    CGFloat likeX = SCREENW - commentW - 2 * kPadding - 100;
    CGFloat likeY = timeY;
    CGFloat likeW = 30;
    CGFloat likeH = 25;
    _likeFrame = CGRectMake(likeX, likeY, likeW, likeH);
    
    _cellHeight = CGRectGetMaxY(_commentFrame) + kPadding;
    
    // 回复评论大小计算
    for (NSInteger i = 0; i < [self.commentGroup.replyArr count]; i++) {
        // 获取字符串
        NSString *reply = self.commentGroup.replyArr[i];
        
        CGFloat replyX = nameX;
        CGFloat replyY = _cellHeight;
        CGSize replySize = [self sizeWithFont:kReplytextFont withString:reply];
        CGFloat replyW = replySize.width;
        CGFloat replyH = replySize.height;
        CGRect replyFrame = CGRectMake(replyX, replyY, replyW, replyH);
        
        [self.replysArray addObject:[NSValue valueWithCGRect:replyFrame]];
        
        // 累加得到高度
        _cellHeight += replyH + kPadding;
    }
}

// 自动计算文本宽高
- (CGSize)sizeWithFont:(UIFont *)font withString:(NSString *)string
{
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREENW - 3 * kPadding - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

// 添加新回复
- (void)addNewReply:(NSString *)text
{
    [self.commentGroup addReply:text];
    
    CGFloat replyX = _shuoshuoTextFrame.origin.x;
    CGFloat replyY = _cellHeight;
    CGSize replySize = [self sizeWithFont:kReplytextFont withString:text];
    CGFloat replyW = replySize.width;
    CGFloat replyH = replySize.height;
    CGRect replyFrame = CGRectMake(replyX, replyY, replyW, replyH);
    
    [self.replysArray addObject:[NSValue valueWithCGRect:replyFrame]];
    
    // 累加得到高度
    _cellHeight += replyH + kPadding;
}

@end
