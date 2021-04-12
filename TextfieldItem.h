#import "MenuItem.h"

@interface TextfieldItem : MenuItem

@property (nonatomic) NSString *Description;
@property (nonatomic) BOOL IsOn;
@property (nonatomic) BOOL IsFloating;
@property (nonatomic) NSString *DefaultValue;

- (id)initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ defaultValue:(NSString *)defaultValue_;
@end