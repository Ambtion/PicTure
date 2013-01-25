//
//  SCPLabelBox.m
//  SohuCloudPics
//
//  Created by Zhong Sheng on 12-9-19.
//  Copyright (c) 2012年 sohu.com. All rights reserved.
//

#import "SCPLabelBox.h"

#import <QuartzCore/QuartzCore.h>



#define LEFT_EDGE 15



@implementation SCPLabelObject

@synthesize labelContent = _labelContent;
@synthesize labelColorStyle = _labelColorStyle;

- (void)dealloc
{
    [_labelContent release];
    [super dealloc];
}

- (id)initWithContent:(NSString *)content colorStyle:(SCPLabelColorStyle)style
{
    self = [super init];
    if (self) {
        _labelContent = [content retain];
        _labelColorStyle = style;
    }
    return self;
}

@end


@interface SCPLabelView : UIButton

@property (assign, nonatomic) UIView *parentBox;
@property (assign, nonatomic) SCPLabelObject *labelObject;

@end


@implementation SCPLabelView

@synthesize parentBox = _parentBox;
@synthesize labelObject = _labelObject;

- (id)init
{
    self = [super init];
    if (self) {
        _parentBox = nil;
        _labelObject = nil;
        
        self.layer.cornerRadius = 5.0;
        self.clipsToBounds = YES;
    }
    return self;
}

- (SCPLabelObject *)labelObject
{
    return _labelObject;
}

- (void)setLabelObject:(SCPLabelObject *)labelObject
{
    _labelObject = labelObject;
    [self setTitle:_labelObject.labelContent forState:UIControlStateNormal];
    
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, LEFT_EDGE, 0, 0);
    
    CGSize size = [_labelObject.labelContent sizeWithFont:[UIFont systemFontOfSize:15]];
    CGRect frame = self.frame;
    frame.size.width = size.width + 20 + LEFT_EDGE;
    frame.size.height = 27;
    self.frame = frame;
    
    switch (_labelObject.labelColorStyle) {
        case SCPLabelColorStyleRed:
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_red.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateNormal];
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_red.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateHighlighted];
            break;
        case SCPLabelColorStyleBlue:
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_blue.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateNormal];
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_blue.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateHighlighted];
            break;
        case SCPLabelColorStyleGreen:
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_green.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateNormal];
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_green.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateHighlighted];
            break;
        case SCPLabelColorStyleYellow:
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_yellow.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateNormal];
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_yellow.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateHighlighted];
            break;
        case SCPLabelColorStyleLightBlue:
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_light_blue.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateNormal];
            [self setBackgroundImage:[[UIImage imageNamed:@"tag_light_blue.png"] stretchableImageWithLeftCapWidth:41 topCapHeight:0] forState:UIControlStateHighlighted];
            break;
        default:
            break;
    }
}

- (void)setParentBox:(SCPLabelBox *)parentBox
{
    _parentBox = parentBox;
    [self addTarget:_parentBox action:@selector(labelViewClicked:) forControlEvents:UIControlEventTouchUpInside];
}

@end



@implementation SCPLabelBox

@synthesize delegate = _delegate;

@synthesize addLabelButton = _addLabelButton;

- (void)dealloc
{
    [_labelObjects release];
    [_addLabelButton release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelObjects = [[NSMutableArray alloc] init];
        _insertPoint = CGPointMake(10, 10);
        
        _addLabelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _addLabelButton.frame = CGRectMake(10, 10, 44, 27);
        [_addLabelButton setImage:[UIImage imageNamed:@"tag_add.png"] forState:UIControlStateNormal];
        [_addLabelButton setImage:[UIImage imageNamed:@"tag_add_press.png"] forState:UIControlStateHighlighted];
        [_addLabelButton setImage:[UIImage imageNamed:@"tag_add_press.png"] forState:UIControlStateSelected];
        [_addLabelButton setImage:[UIImage imageNamed:@"tag_add_press.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_addLabelButton addTarget:self action:@selector(addLabelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addLabelButton];
        
        CGRect frame = self.frame;
        frame.size.height = 47;
        self.frame = frame;
    }
    return self;
}

- (void)addLabelButtonClicked
{
    [_delegate SCPLabelBox:self addLabelButtonClicked:_addLabelButton];
}

- (void)labelViewClicked:(id)sender
{
    int index, length = _labelObjects.count;
    for (index = 0; index < length; ++index) {
        if ([_labelObjects objectAtIndex:index] == ((SCPLabelView *) sender).labelObject) {
            break;
        }
    }
    if ([_labelObjects objectAtIndex:index] != ((SCPLabelView *) sender).labelObject) {
        @throw [[[NSException alloc] initWithName:@"BAD_STATUS" reason:@"NO SUCH LABEL FOUND!!" userInfo:nil] autorelease];
    }
    [_delegate SCPLabelBox:self clickedAtIndex:index label:sender];
    return;

}

#pragma mark
#pragma mark Quering this labelBox
- (NSInteger)labelObjectCount
{
    return _labelObjects.count;
}

- (SCPLabelObject *)labelObjectAtIndex:(NSInteger)index
{
    return [_labelObjects objectAtIndex:index];
}

- (BOOL)labelObjectContains:(SCPLabelObject *)labelObj
{
    return [_labelObjects containsObject:labelObj];
}

#pragma mark
#pragma mark Operating this labelBox
- (void)addLabel:(SCPLabelObject *)labelObject
{
    
    [_labelObjects addObject:labelObject];
    SCPLabelView *labelView = [[SCPLabelView alloc] init];
    labelView.parentBox = self;
    labelView.labelObject = [_labelObjects lastObject];
    
    CGRect frame;
    CGSize size = labelView.frame.size;
    if (size.width > 300.0) {
        [labelView release];
        @throw [[[NSException alloc] initWithName:@"BAD_LABEL_SIZE" reason:@"The label is too loooooooooooooooooog!" userInfo:nil] autorelease];
    }
    if (_insertPoint.x + size.width <= 300.0) {
        frame = CGRectMake(_insertPoint.x, _insertPoint.y, size.width, 27);
    } else {
        _insertPoint.y += 27 + 10;
        frame = CGRectMake(10, _insertPoint.y, size.width, 27);
    }
    labelView.frame = frame;
    _insertPoint.x = frame.origin.x + size.width + 15;
    if (_insertPoint.x + 44 > 300.0) {
        _insertPoint.x = 10;
        _insertPoint.y += 27 + 10;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    {
        CGRect frame = self.frame;
        frame.size.height = _insertPoint.y + 27 + 10;
        self.frame = frame;
        _addLabelButton.frame = CGRectMake(_insertPoint.x, _insertPoint.y, 44, 27);
    }
    [UIView commitAnimations];
    
    [self performSelector:@selector(addSubview:) withObject:labelView afterDelay:0.3];
    
    [labelView release];
    
}

- (void)removeLabelAtIndex:(NSInteger)index
{
    NSMutableArray * subviews = [NSMutableArray arrayWithCapacity:0];
    for (UIView *view in self.subviews) {
        if ([view class] == [SCPLabelView class]) {
            [subviews addObject:view];
        }
    }
    
    SCPLabelObject * obj = [_labelObjects objectAtIndex:index];
    SCPLabelView *labelView = [subviews objectAtIndex:index];
    
    if (labelView.labelObject != obj) {
        @throw [[[NSException alloc] initWithName:@"BAD_STATUS" reason:@"NO SUCH LABEL FOUND!!" userInfo:nil] autorelease];
    }
    
    [_labelObjects removeObjectAtIndex:index];
    [labelView removeFromSuperview];
    
    subviews = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (UIView *view in self.subviews) {
        if ([view class] == [SCPLabelView class]) {
            [subviews addObject:view];
        }
    }
    
    int count = subviews.count;
    int needRerange = count - index;
    CGRect * destFrames = malloc(needRerange * sizeof(CGRect));
    
    if (index == 0) {
        _insertPoint = CGPointMake(10, 10);
    } else {
        labelView = [subviews objectAtIndex:index - 1];
        _insertPoint.x = labelView.frame.origin.x + labelView.frame.size.width + 15;
        _insertPoint.y = labelView.frame.origin.y;
        if (_insertPoint.x > 300.0) {
            _insertPoint.x = 10;
            _insertPoint.y += 27 + 10;
        }
    }
    for (int i = index; i < count; ++i) {
        labelView = [subviews objectAtIndex:i];
        CGRect frame = labelView.frame;
        if (_insertPoint.x + frame.size.width > 300.0) {
            _insertPoint.x = 10;
            _insertPoint.y += 27 + 10;
        }
        frame.origin.x = _insertPoint.x;
        frame.origin.y = _insertPoint.y;
        destFrames[i - index] = frame;
        _insertPoint.x = frame.origin.x + frame.size.width + 15;
        if (_insertPoint.x + 44 > 300.0) {
            _insertPoint.x = 10;
            _insertPoint.y += 27 + 10;
        }
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    {
        for (int i = index; i < count; ++i) {
            labelView = [subviews objectAtIndex:i];
            labelView.frame = destFrames[i - index];
        }
        CGRect frame = self.frame;
        frame.size.height = _insertPoint.y + 27 + 10;
        self.frame = frame;
        _addLabelButton.frame = CGRectMake(_insertPoint.x, _insertPoint.y, 44, 27);
    }
    [UIView commitAnimations];
    free(destFrames);
}

@end




@implementation SCPLabelChooser

@synthesize delegate = _delegate;

@synthesize labelObjects = _labelObjects;

@synthesize backgroundImageView = _backgroundImageView;
@synthesize titleBackgroundImageView = _titleBackgroundImageView;
@synthesize titleLabel = _titleLabel;
@synthesize foldButton = _foldButton;
@synthesize labelScroll = _labelScroll;
@synthesize labelPageControl = _labelPageControl;

- (void)dealloc
{
    [_labelObjects release];
    [_backgroundImageView release];
    [_titleBackgroundImageView release];
    [_titleLabel release];
    [_labelScroll release];
    [_labelPageControl release];
    
    [super dealloc];
}

- (id)initWithLabels:(NSArray *)labels
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 137)]; // height is fixed to 137
    if (self) {
        _labelObjects = [labels retain];
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 137)];
        _backgroundImageView.image = [UIImage imageNamed:@"drewer_white_bg.png"];
        _backgroundImageView.autoresizesSubviews = YES;
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_backgroundImageView];
        
        _titleBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        _titleBackgroundImageView.image = [UIImage imageNamed:@"drewer_title.png"];
        _titleBackgroundImageView.autoresizesSubviews = YES;
        _titleBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_titleBackgroundImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRed:98.0 / 255 green:98.0 / 255 blue:98.0 / 255 alpha:1];
        _titleLabel.text = @"请选择标签";
        _titleLabel.autoresizesSubviews = YES;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_titleLabel];
        
        _foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _foldButton.frame = CGRectMake(275, 4, 35, 22);
        _foldButton.autoresizesSubviews = YES;
        _foldButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_foldButton setImage:[UIImage imageNamed:@"drewer_btn_normal.png"] forState:UIControlStateNormal];
        [_foldButton setImage:[UIImage imageNamed:@"drewer_btn_press.png"] forState:UIControlStateHighlighted];
        [_foldButton addTarget:self action:@selector(foldButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_foldButton];
        
        _labelScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, 320, 102)];
        int page = 0;
        UIView *pageView = nil;
        int line = 0;
        CGPoint insertPoint = CGPointMake(15, 10);
        int count = _labelObjects.count;
        for (int i = 0; i < count; ++i) {
            // start a new page
            if (line == 0 && insertPoint.x == 15) {
                pageView = [[UIView alloc] initWithFrame:CGRectMake(page * 320, 0, 320, 102)];
                [_labelScroll addSubview:pageView];
                ++page;
                [pageView release]; // note that pageView can be still used
            }
            
            SCPLabelView *view = [[[SCPLabelView alloc] init] autorelease];
            view.labelObject = [_labelObjects objectAtIndex:i];
            view.parentBox = self;
            
            CGSize size = view.frame.size;
            if (size.width > 300.0) {
                @throw [[[NSException alloc] initWithName:@"BAD_LABEL_SIZE" reason:@"The label is too loooooooooooooooooog!" userInfo:nil] autorelease];
            }
            
            if (insertPoint.x + size.width <= 305.0) {
                view.frame = CGRectMake(insertPoint.x, insertPoint.y, size.width, 27);
                [pageView addSubview:view];
                insertPoint.x += size.width + 15;
            } else {
                if (line == 0) {
                    // 换行
                    line = 1;
                    insertPoint.x = 15;
                    insertPoint.y = 50;
                } else {
                    // 换页
                    line = 0;
                    insertPoint.x = 15;
                    insertPoint.y = 10;
                }
                --i;
            }
        }
        _labelScroll.contentSize = CGSizeMake(page * 320, 102);
        _labelScroll.showsHorizontalScrollIndicator = NO;
        _labelScroll.pagingEnabled = YES;
        _labelScroll.delegate = self;
        [self addSubview:_labelScroll];
        
        _labelPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 127, 320, 5)];
        _labelPageControl.hidesForSinglePage = YES;
        _labelPageControl.numberOfPages = page;

        //        _labelPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:161.0 / 255 green:161.0 / 255 blue:161.0 / 255 alpha:1];
        //        _labelPageControl.pageIndicatorTintColor = [UIColor colorWithRed:203.0 / 255 green:203.0 / 255 blue:203.0 / 255 alpha:1];
        [_labelPageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_labelPageControl];
    }
    return self;
}

- (void)foldButtonClicked
{
    
    [_delegate SCPLabelChooser:self foldButtonClicked:_foldButton];
}

- (void)labelViewClicked:(id)sender
{
    //    [_delegate SCPLabelChooser:self clickedAtIndex:0 label:sender];
    [_delegate SCPLabelChooser:self clickedAtObj:((SCPLabelView *) sender).labelObject];
}

#pragma mark
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int offset = _labelScroll.contentOffset.x;
    _labelPageControl.currentPage = (offset + 161) / 320;
}

#pragma mark
#pragma mark UIPageControl target
- (void)pageControlValueChanged:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_labelScroll cache:NO];
    _labelScroll.contentOffset = CGPointMake(320 * _labelPageControl.currentPage, 0);
    [UIView commitAnimations];
}

@end


