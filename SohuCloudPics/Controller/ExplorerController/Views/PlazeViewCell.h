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
- (void)PlazeViewCell:(PlazeViewCell *)cell imageClick:(UIImageView * )imageView;
@end

@interface PlazeViewCell : UITableViewCell
{
    PlazeViewCellDataSource * _dataSource;
    NSMutableArray * _imageViewArray;
    id<PlazeViewCellDelegate> _delegate;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andframe:(NSArray *)frames height:(CGFloat)height;
@property (nonatomic,retain) PlazeViewCellDataSource * dataSource;
@property (nonatomic,assign) id<PlazeViewCellDelegate> delegate;
@end
