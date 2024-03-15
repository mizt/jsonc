#import <Foundation/Foundation.h>

typedef struct _Params {
	int quality = 100;
	NSMutableString *type = [NSMutableString stringWithString:@"default"];
} Params;

class Settings {
	
	protected:
	
		Params params;
	
	private:
		
		bool isSameClassName(id a, NSString *b) { return (a&&[[a className] compare:b]==NSOrderedSame); }
		bool isNumber(id a) { return isSameClassName(a,@"__NSCFNumber"); }
		bool isString(id a) { return isSameClassName(a,@"NSTaggedPointerString"); }
		bool isBoolean(id a) { return isSameClassName(a,@"__NSCFBoolean"); }
		bool isArray(id a) { return isSameClassName(a,@"__NSArrayM"); }
		bool isMatrix(id a) { return (isSameClassName(a,@"__NSArrayM")&&[a count]==16); }
		
	public:
	
		Settings(NSString *path) {
			NSString *jsonc = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
			if(jsonc&&jsonc.length>0) {
				settings = [NSJSONSerialization JSONObjectWithData:[[[NSRegularExpression regularExpressionWithPattern:@"(/\\*[\\s\\S]*?\\*/|//.*)" options:1 error:nil] stringByReplacingMatchesInString:jsonc options:0 range:NSMakeRange(0,jsonc.length) withTemplate:@""] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
				if(this->isNumber(settings[@"quality"])) this->params.quality = [settings[@"quality"] intValue];
				if(this->isString(settings[@"type"])) [this->params.type setString:settings[@"type"]];
			}
			NSLog(@"quality = %d",this->params.quality);
			NSLog(@"type = %@",this->params.type);
		}
};

class App : public Settings {
	
	public:
	
		App(NSString *path):Settings(path) {}
};

int main(int argc, char *argv[]) {
	@autoreleasepool {
		new App(@"./settings.jsonc");
	}
}