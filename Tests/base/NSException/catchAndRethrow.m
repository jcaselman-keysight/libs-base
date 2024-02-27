#import "Testing.h"
#import <Foundation/Foundation.h>

int main()
{
    START_SET("Catch and rethrow NSException")
    NS_DURING
        NS_DURING
            // Your code that might throw an exception
            [NSException raise:@"OldStyleHelloWorldException" format:@"Hello, World! NS_DURING exception thrown."];
        NS_HANDLER
            NSLog(@"Caught an exception: %@", localException);
            [localException raise]; // Re-throw the caught exception
        NS_ENDHANDLER
    NS_HANDLER
        NSLog(@"Caught another exception: %@", localException);
        PASS(YES, "Rethrowing is caught by outer handler");
    NS_ENDHANDLER
    END_SET("Catch and rethrow NSException")
    return 0;
}