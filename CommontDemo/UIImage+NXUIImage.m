//
//  UIImage+NXUIImage.m
// 
//
//  Created by liuhuiliang on 16/1/19.
//  Copyright © 2016年 nianxin. All rights reserved.
//

#import "UIImage+NXUIImage.h"

@implementation UIImage (NXUIImage)


+(instancetype)stretchImage:(NSString *)named{

    UIImage *targetImage=[UIImage imageNamed:named];
    
    
    return [targetImage stretchableImageWithLeftCapWidth:targetImage.size.width*0.5 topCapHeight:targetImage.size.height*0.5];

}



/**
 *  截取圆形图片
 *
 *  @param imagePath 图片路径
 *
 *  @return 图片
 */
-(instancetype)circleImage{

    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);

    //获取上下文
    CGContextRef ref=UIGraphicsGetCurrentContext();
    
    
    CGRect rect=CGRectMake(0, 0, self.size.width, self.size.height);
    
    //绘制圆形图片
    CGContextAddEllipseInRect(ref, rect);

    //截取边缘
    CGContextClip(ref);
    
    //画到Uiimage
    [self drawInRect:rect];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;

    
}


@end
