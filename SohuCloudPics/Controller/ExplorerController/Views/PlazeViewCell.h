//
//  SohuCloudPics
//
//  Created by sohu on 12-11-16.
//
//

#import <UIKit/UIKit.h>


@interface PlazeViewCellDataSource : NSObject

@property (nonatomic,retain) NSArray * viewRectFrame;
@property (nonatomic,retain) NSArray * imageFrame;
@property (nonatomic,retain) NSArray * infoArray;
@property (nonatomic,assign) CGFloat higth;
@property (nonatomic,retain) NSString * identify;

@end

@class PlazeViewCell;

@protocol PlazeViewCellDelegate <NSObject>
@required
- (void)plazeViewCell:(PlazeViewCell *)cell imageClick:(UIImageView * )imageView;
@end

@interface PlazeViewCell : UITableViewCell
{
    PlazeViewCellDataSource * _dataSource;
    NSMutableArray * _imageViewArray;
    id<PlazeViewCellDelegate> _delegate;
}
@property (nonatomic,assign) id<PlazeViewCellDelegate> delegate;
@property (nonatomic,retain) PlazeViewCellDataSource * dataSource;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andframe:(NSArray *)frames height:(CGFloat)height;

@end
