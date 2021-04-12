#import "MenuItem.h"

@interface InvokeItem : MenuItem

@property (nonatomic) NSString *Description;
@property (nonatomic) void (*FunctionPtr)();

- (id)initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ functionPtr:(void (*)())functionPtr_;

@end