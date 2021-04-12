#import "MenuItem.h"

@interface PageItem : MenuItem

@property (nonatomic) NSUInteger TargetPage;

- (id)initWithTitle:(NSString *)title_ targetPage:(NSUInteger)targetPage_;

@end