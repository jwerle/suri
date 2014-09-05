
/**
 * `suri.m' - suri
 *
 * OSX URI scheme registration
 */

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import "suri.h"

/**
 * Outputs program usage
 */

void
usage () {
  fprintf(stderr, "usage: suri [-hV] <scheme> <application>\n");
}

/**
 * Normalizes a URI scheme
 */

NSString *
normalizeScheme (NSString *scheme) {
  // search for ':' and remove it
  if (NSNotFound != [scheme rangeOfString:@":"].location) {
    scheme = [scheme stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
  }

  return scheme;
}

int
main (int argc, char **argv) {
  // init ARC pool
  @autoreleasepool {
    // work space
    NSWorkspace *workspace = nil;

    // application bundle
    NSBundle *bundle = nil;

    // application uri scheme
    NSString *scheme = nil;

    // application scheme url
    NSURL *url = nil;

    // application name
    NSString *app = nil;

    // application path
    NSString *path = nil;

    // error status
    OSStatus status = 0;

    // output usage with no args
    if (1 == argc) {
      return usage(), 1;
    }

    // parse opts
    if ('-' == argv[1][0]) {
      switch (argv[1][1]) {
        case 'h':
          usage();
          return 0;

        case 'V':
          printf("%s\n", SURI_VERSION);
          return 0;

        default:
          FERROR("error: Unknown option `%c'\n", argv[1][1]);
          usage();
          return 1;
      }
    }

    // initialize workspace
    workspace = [NSWorkspace sharedWorkspace];

    // `char *' to `NSString' for application scheme
    scheme = [NSString stringWithUTF8String: argv[1]];

    // normalize scheme
    scheme = normalizeScheme(scheme);

    // get by uri scheme
    if (2 == argc) {
      // C url reference for url
      CFURLRef curl = nil;

      // get application scheme url
      status = LSGetApplicationForURL(
          (__bridge CFURLRef)(NSURL *)[NSURL URLWithString: scheme],
          kLSRolesViewer, nil, &curl);

      // ensure everything is OK
      switch (status) {
        case noErr:
          // we're good here
          break;

        // not foudn
        case kLSApplicationNotFoundErr:
          FERROR("error: `%s' not found\n", argv[1]);
          return 1;

        // unknown error
        default:
          FERROR("error: An unknown error occured when retrieving application"
              "URL for `%s' in `LSGetApplicationForURL()'\n", argv[1]);
          return 1;
      }

      // set C url references to `url'
      url = (__bridge NSURL *) curl;

      // output
      printf("%s\n", [[url absoluteString] UTF8String]);
      return 0;
    }

    // set application to scheme
    if (3 == argc) {
      // `char *' to `NSString' for application name
      app = [NSString stringWithUTF8String: argv[2]];

      // get application path
      path = [workspace fullPathForApplication: app];

      // get application bundle
      bundle = [NSBundle bundleWithPath: path];

      // set scheme for application
      status = LSSetDefaultHandlerForURLScheme(
          (__bridge CFStringRef) scheme,
          (__bridge CFStringRef) [bundle bundleIdentifier]);

      printf("%d\n", status);
      switch (status) {
        case noErr:
          // we were successful !
          break;

        default:
          printf("%d\n", status);
          return 1;
      }

      // output bundle identifier
      printf("Setting scheme `%s' for application bundle `%s'\n",
             [scheme UTF8String],
             [[bundle bundleIdentifier] UTF8String]);

      return 0;
    }

    if (argc > 3) {
      FERROR("error: Invalid argument count %d. Expecting at most 2\n", argc);
      usage();
      return 1;
    }
  }

  return 0;
}
