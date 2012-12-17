//
//  UICliper.m
//  image
//
//  Created by 岩 邢 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UICliper.h"

@implementation UICliper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}
- (id)initWithImageView:(UIImageView*)iv
{
    CGRect r = [iv bounds];
    r.origin.x -= 10;
    r.origin.y -= 10;
    r.size.height += 20;
    r.size.width += 20;
    self = [super initWithFrame:r];
    if (self) {
        
        [iv addSubview:self];
        [iv setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        float size = r.size.height>r.size.width? r.size.width :r.size.height;
        size -= 40;
        
        cliprect = CGRectMake((r.size.width-size)/2, (r.size.height-size)/2, size, size);
         
        grayAlpha = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.6]  ;
        [self setMultipleTouchEnabled:NO];
        touchPoint = CGPointZero;
        imgView = iv;
        
        pointImage = [[UIImage imageNamed:@"point.png"] retain];

        view = [[UIImageView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor  clearColor];
        [self addSubview:view];
        view.image = [self getImage:self.frame];
        
    }
    return self;
}
#pragma mark -
#pragma mark - getClipImage
- (UIImage*)getImage:(CGRect)rect
{
    CGFloat scale = 1;
    CGRect rectSacle = rect;
    
    rectSacle.size.width *= scale;
    rectSacle.size.height *= scale;
    
    CGRect clipScale = cliprect;
    clipScale.origin.x *= scale;
    clipScale.origin.y *= scale;
    clipScale.size.width *= scale;
    clipScale.size.height *= scale;
    
    UIGraphicsBeginImageContext(rectSacle.size);
    CGContextRef context= UIGraphicsGetCurrentContext();
    
    //绘制背景透明色
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rectSacle);

    //绘制透明灰色
    CGContextSetFillColorWithColor(context, grayAlpha.CGColor);
    CGContextFillRect(context, CGRectMake(10 * scale, 10 * scale, rectSacle.size.width - 20 * scale, rectSacle.size.height - 20 *scale));
    
    //绘制出区域部分
    CGContextClearRect(context, clipScale);
    
    //绘制剪裁区域的格子
    
    CGContextSetRGBStrokeColor(context, 245/255.f, 245.f/255, 245.f/255.f, 0.3f);
    CGContextSetLineWidth(context, 1.0 * scale);
    CGRect rect1 = clipScale;
    rect1.origin.x -=1;
    rect.origin.y -= 1;
    rect1.size.width+=1;
    rect1.size.height+=1;
    
    CGContextAddRect(context, clipScale);
    
    CGContextMoveToPoint(context, clipScale.origin.x+clipScale.size.width/3, clipScale.origin.y);
    CGContextAddLineToPoint(context, clipScale.origin.x+clipScale.size.width/3, clipScale.origin.y+clipScale.size.height);
    CGContextMoveToPoint(context, clipScale.origin.x+clipScale.size.width/3*2, clipScale.origin.y);
    CGContextAddLineToPoint(context, clipScale.origin.x+clipScale.size.width/3*2, clipScale.origin.y+clipScale.size.height);
    
    CGContextMoveToPoint(context, clipScale.origin.x, clipScale.origin.y+clipScale.size.height/3);
    CGContextAddLineToPoint(context, clipScale.origin.x+clipScale.size.width, clipScale.origin.y+clipScale.size.height/3);
    CGContextMoveToPoint(context, clipScale.origin.x, clipScale.origin.y+clipScale.size.height/3*2);
    CGContextAddLineToPoint(context, clipScale.origin.x+clipScale.size.width, clipScale.origin.y+clipScale.size.height/3*2);
    CGContextStrokePath(context);
    
    // 绘制边线
    CGContextSetRGBStrokeColor(context, 245/255.f, 245.f/255, 245.f/255.f, 1.f);
    CGContextSetLineWidth(context, 2.0f * scale);
    CGContextMoveToPoint(context, clipScale.origin.x, clipScale.origin.y);
    CGContextAddLineToPoint(context, clipScale.origin.x + clipScale.size.width, clipScale.origin.y);
    CGContextAddLineToPoint(context, clipScale.origin.x + clipScale.size.width, clipScale.origin.y + clipScale.size.height);
    CGContextAddLineToPoint(context, clipScale.origin.x, clipScale.origin.y + clipScale.size.height);
    CGContextAddLineToPoint(context, clipScale.origin.x, clipScale.origin.y);
    CGContextStrokePath(context);
    
    //绘制按钮
    [pointImage drawInRect:CGRectMake(clipScale.origin.x - 13.5 *scale, clipScale.origin.y - 13.5 *scale, 27 * scale, 27 *scale)];
    [pointImage drawInRect:CGRectMake(clipScale.origin.x - 13.5*scale, clipScale.origin.y -
                                      13.5*scale + clipScale.size.height,27*scale, 27*scale)];
    [pointImage drawInRect:CGRectMake(clipScale.origin.x - 13.5*scale+ clipScale.size.width,
                                      clipScale.origin.y - 13.5*scale + clipScale.size.height, 27*scale, 27*scale)];
    [pointImage drawInRect:CGRectMake(clipScale.origin.x - 13.5*scale + clipScale.size.width,
                                      clipScale.origin.y - 13.5*scale, 27*scale, 27*scale)];
    UIImage* outputimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputimage;
}
- (void)resetView
{
    view.image = [self getImage:self.frame];
}

#pragma mark -
#pragma mark touch Method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    touchPoint = [touch locationInView:self];
}

//休整剪切区域
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    float x1=.0f, x2=.0f, y1=.0f, y2=.0f;
    float x = touchPoint.x;
    float y = touchPoint.y;
    
    if (fabsf(x-cliprect.origin.x)<20) //左
    {
        float offy = y-cliprect.origin.y;
        if (fabsf(offy)<20) { //左上角
            x1 = p.x - touchPoint.x;
            y1 = p.y - touchPoint.y;
        }else if(fabsf(offy-cliprect.size.height)<20){ //左下角
            x1 = p.x - touchPoint.x;
            y2 = p.y - touchPoint.y;
        }else if(y>cliprect.origin.y && y<cliprect.origin.y+cliprect.size.height) { //左中部
            //            x1 = p.x - touchPoint.x;
        }
    }else if(fabsf(x-cliprect.origin.x-cliprect.size.width)<20) //右
    {
        float offy = y-cliprect.origin.y;
        if (fabsf(offy)<20) { //右上角
            x2 = p.x -touchPoint.x;
            y1 = p.y -touchPoint.y;
        }else if(fabsf(offy-cliprect.size.height)<20) { //右下角
            x2 = p.x - touchPoint.x;
            y2 = p.y - touchPoint.y;
        }else if(y>cliprect.origin.y && y<cliprect.origin.y+cliprect.size.height) { //右中部
            //            x2 = p.x - touchPoint.x;
        }
    }else if(fabsf(y-cliprect.origin.y)<20){ //上
        //        if (x>cliprect.origin.x && x< cliprect.size.width) { //上中
        //            y1 = p.y - touchPoint.y;
        //        }
    }else if(fabsf(y-cliprect.origin.y-cliprect.size.height)<20){ //下
        //        if (x>cliprect.origin.x && x< cliprect.size.width) { //下中
        //            y2 = p.y - touchPoint.y;
        //        }
    }else if((x>cliprect.origin.x && x< cliprect.origin.x+cliprect.size.width)&&(y>cliprect.origin.y && y<cliprect.origin.y+cliprect.size.height)){
        //方框中移动
        cliprect.origin.x += (p.x -touchPoint.x);
        cliprect.origin.y += (p.y -touchPoint.y);
        
    }else {
        return;
    }
    //修改rect
    [self ChangeclipEDGE:x1 x2:x2 y1:y1 y2:y2];
    [self resetView];

    touchPoint = p;
}

//休整剪切区域
- (CGRect)ChangeclipEDGE:(float)x1 x2:(float)x2 y1:(float)y1 y2:(float)y2
{

    cliprect.origin.x += x1;
    cliprect.size.width -= x1;
    cliprect.origin.y += y1;
    cliprect.size.height -= y1;
    
    cliprect.size.width += x2;
    cliprect.size.height += y2;
    
    //限制移动
    if (cliprect.origin.x < 10) {
        cliprect.origin.x = 10;
    }else if(cliprect.origin.x > self.bounds.size.width-cliprect.size.width - 10){
        cliprect.origin.x = self.bounds.size.width-cliprect.size.width - 10;
    }
    if (cliprect.origin.y < 10) {
        cliprect.origin.y = 10;
    }else if(cliprect.origin.y > self.bounds.size.height - cliprect.size.height - 10){
        cliprect.origin.y = self.bounds.size.height - cliprect.size.height - 10;
    }
    if (cliprect.size.width<100) {
        if (x1>0.f) {
            cliprect.origin.x -= 100.f - cliprect.size.width;
        }
        cliprect.size.width = 100.f;
    }else if(cliprect.size.height<100.f) {
        if (y1>0.f) {
            cliprect.origin.y -= 100.f - cliprect.size.height;
        }
        cliprect.size.height = 100.f;
    }
    [self recrectClipRect];
    return cliprect;
}
-(void)recrectClipRect
{
    if (cliprect.origin.x < 10) {
        cliprect.origin.x = 10;
    }
    if (cliprect.origin.y < 10) {
        cliprect.origin.y = 10;
    }
    if (cliprect.size.width > self.bounds.size.width - cliprect.origin.x - 10) {
        cliprect.size.width = self.bounds.size.width - cliprect.origin.x - 10;
    }
    if (cliprect.size.height > self.bounds.size.height - cliprect.origin.y - 10 ) {
        cliprect.size.height = self.bounds.size.height - cliprect.origin.y - 10;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchPoint = CGPointZero;
    [self resetView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)setclipEDGE:(CGRect)rect
{
    cliprect = rect;
    [self resetView];
}

- (void)dealloc
{
    
    [super dealloc];
}

- (CGRect)getclipRect
{
    [self ChangeclipEDGE:0 x2:0 y1:0 y2:0];
    [self resetView];
    
    CGRect rect = cliprect;
    rect.origin.x -= 10;
    rect.origin.y -= 10;
    float imgsize = [imgView image].size.width;
    float viewsize = [imgView frame].size.width;
    float scale = imgsize/viewsize;
    CGRect r = CGRectMake(cliprect.origin.x*scale, cliprect.origin.y*scale, cliprect.size.width*scale, cliprect.size.height*scale);
   
    return r;
}

-(void)setClipRect:(CGRect)rect
{
    cliprect = rect;
    [self resetView];
}

-(UIImage*)getClipImageRect:(CGRect)rect
{
    CGImageRef imgrefout = CGImageCreateWithImageInRect([imgView.image CGImage], rect);
    UIImage *img_ret = [[[UIImage alloc]initWithCGImage:imgrefout] autorelease];
    CGImageRelease(imgrefout);
    return img_ret;
}

-(CGRect)cliprect{
    CGRect rect = cliprect;
    rect.origin.x -= 10;
    rect.origin.y -= 10;
    return rect;
}
@end
