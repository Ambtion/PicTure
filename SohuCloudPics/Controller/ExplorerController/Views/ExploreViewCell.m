//
//  ExploreCell2.m
//  SohuCloudPics
//
//  Created by sohu on 12-11-16.
//
//

#import "ExploreViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation ExploreViewCellDataSource
@synthesize viewRectFrame = _viewRectFrame;
@synthesize imageFrame = _imageFrame;
@synthesize infoArray = _infoArray;
@synthesize identify = _identify;
@synthesize heigth = _heigth;
- (void)dealloc
{
    [_viewRectFrame release];
    [_imageFrame release];
    [_infoArray release];
    [_identify  release];
    [super dealloc];
}

@end

@implementation ExploreViewCell
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_dataSource release];
    [_imageViewArray release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andframe:(NSArray *)frames height:(CGFloat)height
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        self.frame = CGRectMake(0, 0, 320, height);
        _imageViewArray = [[NSMutableArray arrayWithCapacity:0] retain];
        [self addSubviewsWith:frames];
    }
    return self;
}
- (void)addSubviewsWith:(NSArray *)frames
{
    
    UIImageView * imageView = nil;
    UIView * view  = nil;
    for (int i = 0; i < frames.count; i++) {
        view = [[UIView alloc] initWithFrame:[(NSValue *)[frames objectAtIndex:i] CGRectValue]];
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;
    
//        imageView = [[UIImageView alloc] initWithFrame:[(NSValue *)[frames objectAtIndex:i] CGRectValue]];
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.tag = i;
        imageView.image = [UIImage imageNamed:@"default_cell.png"];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlegesture:)];
        [imageView addGestureRecognizer:gesture];
        [imageView setUserInteractionEnabled:YES];
        [view addSubview:imageView];
        [self.contentView addSubview:view];
        [_imageViewArray addObject:imageView];
                
        [gesture release];
        [imageView release];
        [view release];
    }
    
}
- (void)handlegesture:(UITapGestureRecognizer *)gesture
{
    UIImageView * imageview = (UIImageView *)[gesture view];
    if ([_delegate respondsToSelector:@selector(exploreCell:imageClick:)]) {
        [_delegate exploreCell:self imageClick:imageview];
    }
}
#pragma mark dataSouce
- (ExploreViewCellDataSource * )dataSource
{
    return _dataSource;
}

- (void)setDataSource:(ExploreViewCellDataSource *)dataSource
{
    
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updateImageView];
    }
}
//- (void)setImageViewFrame:(UIImageView *)imageView :(NSDictionary *)dic
//{
//    CGRect superRect = imageView.superview.frame;
//    
//    CGFloat heigth = [[dic objectForKey:@"height"] floatValue];
//    CGFloat wigth = [[dic objectForKey:@"width"] floatValue];
//    if (!heigth || !wigth) {
//        imageView.frame = imageView.superview.bounds;
//        return;
//    }
//    CGFloat scale = MIN(heigth/superRect.size.height, wigth/superRect.size.width);
//    CGRect frame = CGRectMake(0, 0, wigth/scale, heigth/scale);
//  
//    imageView.frame = frame;
//    imageView.center = CGPointMake(imageView.superview.frame.size.width/2.f, imageView.superview.frame.size.height/2.f);
//  
////    NSLog(@"ImageViewFrame %@",NSStringFromCGRect(imageView.frame));
////    NSLog(@"imageSize :%@ ",NSStringFromCGSize((CGSize){wigth,heigth}));
////    NSLog(@"viewFrame : %@",NSStringFromCGRect(imageView.superview.bounds));
//}

- (void)updateImageView
{
    
    for (int i = 0; i < _dataSource.infoArray.count; i++) {
        NSDictionary * dic = [_dataSource.infoArray objectAtIndex:i];
        UIImageView * imageView = [_imageViewArray objectAtIndex:i];
//        [self setImageViewFrame:imageView :dic];
        imageView.frame = [[_dataSource.imageFrame objectAtIndex:i] CGRectValue];
        
        //现在取图283w
        NSURL * url = [NSURL URLWithString:[dic objectForKey:@"url"]];
        [imageView setImageWithURL:url placeholderImage:nil options:0];
    }
}
@end
