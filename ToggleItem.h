#import "MenuItem.h"

@interface ToggleItem : MenuItem

@property (nonatomic) NSString *Description;
@property (nonatomic) BOOL IsOn;

- (id)initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_;

@end