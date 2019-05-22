#if defined(DM_PLATFORM_IOS) || defined(DM_PLATFORM_OSX)
#include <Foundation/Foundation.h>
#include <dmsdk/sdk.h>

char const* PPReader_read(char const* path) {
  NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithUTF8String:path]];
  
  if(!data){
    return nil;
  }
  
  NSPropertyListFormat format;
  NSString *errorDesc = nil;
  NSDictionary * dict = (NSDictionary*)[NSPropertyListSerialization
  propertyListFromData:data
  mutabilityOption:NSPropertyListMutableContainersAndLeaves
  format:&format
  errorDescription:&errorDesc];

  NSError * err;
  NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
  NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  const char *result = [myString UTF8String];
  return result;
}

char const* PPReader_getPath(char const* path) {
  return [[[NSString stringWithUTF8String:path] stringByExpandingTildeInPath] UTF8String];
}

#endif