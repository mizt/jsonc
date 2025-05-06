#import <Foundation/Foundation.h>

namespace TypeCheck {
	bool isSameClassName(id a, NSString *b) { return (a&&[NSStringFromClass([a class]) compare:b]==NSOrderedSame); }
	bool isNumber(id a) { return isSameClassName(a,@"__NSCFNumber"); }
	bool isBoolean(id a) { return isSameClassName(a,@"__NSCFBoolean"); }
	bool isString(id a) { return isSameClassName(a,@"NSTaggedPointerString")||isSameClassName(a,@"__NSCFString"); }
	bool isArray(id a) { return isSameClassName(a,@"__NSArrayM"); }
	bool isDictionary(id a) { return isSameClassName(a,@"__NSDictionaryM"); }
	bool isMatrix3x3(id a) { return (isArray(a)&&[a count]==9); }
	bool isMatrix4x4(id a) { return (isArray(a)&&[a count]==16); }
}

typedef struct _Params {
	int quality = 100;
	NSMutableString *type = [NSMutableString stringWithString:@"default"];
} Params;

class Settings {
	
	protected:
	
		Params params;
	
	public:
	
		Settings(NSString *path) {
			NSString *jsonc = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
			if(jsonc&&jsonc.length>0) {
				settings = [NSJSONSerialization JSONObjectWithData:[[[NSRegularExpression regularExpressionWithPattern:@"(/\\*[\\s\\S]*?\\*/|//.*)" options:1 error:nil] stringByReplacingMatchesInString:jsonc options:0 range:NSMakeRange(0,jsonc.length) withTemplate:@""] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
				if(TypeCheck::isNumber(settings[@"quality"])) this->params.quality = [settings[@"quality"] intValue];
				if(TypeCheck::isString(settings[@"type"])) [this->params.type setString:settings[@"type"]];
			}
			NSLog(@"quality = %d",this->params.quality);
			NSLog(@"type = %@",this->params.type);
		}
};

class App : public Settings {
	
	public:
	
		App(NSString *path):Settings(path) {
			
		}
};

int main(int argc, char *argv[]) {
	@autoreleasepool {
		new App(@"./settings.jsonc");
	}
}