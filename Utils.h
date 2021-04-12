static bool showAlerts = true;

//Waiting normal alerts list
static NSMutableArray *alertsList = [NSMutableArray new];

//C style
static void showPopup(const char *title, const char *description, bool recall = false){
	if(!showAlerts) return;
	
	//Add new alert to waiting list
	if(!recall)
	{
		//Get latest parameters
		NSString *myTitle = [NSString stringWithUTF8String:title];
		NSString *myMessage = [NSString stringWithUTF8String:description];

		//Make a window for alert
		UIWindow *topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		topWindow.rootViewController = [UIViewController new];

		//Add lastest params to alert to list
		NSArray *newAlertStrings = @[myTitle, myMessage, topWindow];

		[alertsList addObject:newAlertStrings];
	}

	//Show alert at index 0
	NSArray *firstAlert = [alertsList objectAtIndex:0];
	UIWindow *currentWindow = [firstAlert objectAtIndex:2];
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:[firstAlert objectAtIndex:0] message:[firstAlert objectAtIndex:1] preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok",@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		// continue your work
		// important to hide the window after work completed.
		// this also keeps a reference to the window until the action is invoked.
		currentWindow.hidden = YES; // if you want to hide the topwindow then use this
		//currentWindow = nil; // if you want to remove the topwindow then use this 
		[alertsList removeObjectAtIndex:0];

		if((int)[alertsList count] > 0){
			showPopup("","",true);
		}

	}]];

	[currentWindow makeKeyAndVisible];
	[currentWindow.rootViewController presentViewController:alert animated:YES completion:nil];
	currentWindow.windowLevel = UIWindowLevelAlert + 1;
}

//Objective-c style
static void showPopup(NSString *title, NSString *description, bool recall = false){
	if(!showAlerts) return;

	if(!recall){
		//Make a window for alert
		UIWindow *topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		topWindow.rootViewController = [UIViewController new];

		//Add lastest params to alert to list
		NSArray *newAlertStrings = @[title, description, topWindow];

		[alertsList addObject:newAlertStrings];
	}

	//Show alert at index 0
	NSArray *firstAlert = [alertsList objectAtIndex:0];
	UIWindow *currentWindow = [firstAlert objectAtIndex:2];
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:[firstAlert objectAtIndex:0] message:[firstAlert objectAtIndex:1] preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok",@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		// continue your work
		// important to hide the window after work completed.
		// this also keeps a reference to the window until the action is invoked.
		currentWindow.hidden = YES; // if you want to hide the topwindow then use this
		//currentWindow = nil; // if you want to remove the topwindow then use this 
		[alertsList removeObjectAtIndex:0];

		if((int)[alertsList count] > 0){
			showPopup(@"",@"",true);
		}
	}]];

	[currentWindow makeKeyAndVisible];
	[currentWindow.rootViewController presentViewController:alert animated:YES completion:nil];
	currentWindow.windowLevel = UIWindowLevelAlert + 1;

}