#import "MenuItem.h"

@implementation MenuItem

@synthesize Title = _Title;

- (void) setTitle:(NSString *)pTitle {
   _Title = pTitle;
}

- (NSString*) Title {
   return _Title;
}

@end