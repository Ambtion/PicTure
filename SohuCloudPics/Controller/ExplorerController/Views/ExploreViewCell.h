//
//  ExploreCell2.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-16.
//
//

#import <UIKit/UIKit.h>


@interface ExploreViewCellDataSource : NSObject
@property (nonatomic,retain) NSArray * viewRectFrame;
@property (nonatomic,retain) NSArray * imageFrame;
@property (nonatomic,retain) NSArray * infoArray;
@property (nonatomic,assign) CGFloat heigth;
@property (nonatomic,retain) NSString * identify;
@end


@class ExploreViewCell;
@protocol ExploreCellDelegate <NSObject>
@required
- (void)exploreCell:(ExploreViewCell *)cell imageClick:(UIImageView * )imageView;
@end

@interface ExploreViewCell : UITableViewCell
{
    ExploreViewCellDataSource * _dataSource;
    NSMutableArray * _imageViewArray;
    id<ExploreCellDelegate> _delegate;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andframe:(NSArray *)frames height:(CGFloat)height;
@property (nonatomic,retain) ExploreViewCellDataSource * dataSource;
@property (nonatomic,assign) id<ExploreCellDelegate> delegate;
@end
