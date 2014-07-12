Angels-Rest
===========

Angels Rest is an app for an animal sanctuary local to Cincinnati.

###Technologies
- Petfinder API (to download cats/dogs)
- Parse SDK (for push notifications)
- PayPal SDK (in-app donations)
- ConstantContact API (email newsletter enrollment)
- AFNetworking
- MBProgressHUD
- DDPageControl
- FPPopover

###Dependencies
This project uses CocoaPods for dependency management, so ensure CocoaPods is installed/up-to-date and run:

    pod install
in the project's root directory (where the podfile is located).

###Private To Public Migration
In moving the project to a public repository, Parse, PayPal, and ConstantContact API keys were removed from the project.  All keys are located in Keys.h.  The phone number and email for contacting Angel's Rest from within the app have also been removed and switched to mock data.

In order to ensure these elements were completely expunged, previous commits have been stripped out of this project.
