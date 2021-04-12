#import "UIKit/UIKit.h"

@interface Page<ObjectType> : NSObject

@property (nonatomic, strong) NSMutableArray<id> *Items;
@property (nonatomic, assign) int PageNumber;
@property (nonatomic, assign) int ParentPage;

- (void)addItem:(ObjectType)item;
- (id)initWithPageNumber:(int)pageNumber_ parentPage:(int)parentPage_;
+ (Page *)pageWithNum:(int)pageNum menuRef:(id)menuRef_;

@end