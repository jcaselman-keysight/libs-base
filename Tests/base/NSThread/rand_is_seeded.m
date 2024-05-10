#import "ObjectTesting.h"
#import <Foundation/Foundation.h>

@interface RandomNumberGenerator : NSObject
@property (atomic, assign) int randomNumber1;
@property (atomic, assign) int randomNumber2;
- (void)generateRandomNumber1;
- (void)generateRandomNumber2;
@end

@implementation RandomNumberGenerator

- (void)generateRandomNumber1 {
    _randomNumber1 = rand();
}

- (void)generateRandomNumber2 {
    _randomNumber2 = rand();
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Seed the random number generator on the main thread
        srand((unsigned int)time(NULL));

        RandomNumberGenerator *generator = [[RandomNumberGenerator alloc] init];

        NSThread *thread1 = [[NSThread alloc] initWithTarget:generator
                                                   selector:@selector(generateRandomNumber1)
                                                     object:nil];
        [thread1 start];

        NSThread *thread2 = [[NSThread alloc] initWithTarget:generator
                                                   selector:@selector(generateRandomNumber2)
                                                     object:nil];
        [thread2 start];

        while (![thread1 isFinished] && ![thread2 isFinished]) {
            [NSThread sleepForTimeInterval:0.01];
        }

        PASS(generator.randomNumber1 != generator.randomNumber2, "Different random numbers should be generated on new threads. thread1: %d, thread2: %d\n", generator.randomNumber1, generator.randomNumber2);        
    }
    return 0;
}
