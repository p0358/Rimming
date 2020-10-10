static NSDictionary<NSString *, NSString *> *strings;

// Replace strings
NSString *stringWithReplacement(NSString *origString, NSString *find, NSString *replace, BOOL caseSensitive) { // options
	NSString *newString;
	if (caseSensitive) {
		newString = [origString stringByReplacingOccurrencesOfString:find withString:replace];
	} else {
		newString = [origString stringByReplacingOccurrencesOfString:find withString:replace options:NSCaseInsensitiveSearch range:NSMakeRange(0, [origString length])];
	}
	return newString;
}
NSAttributedString *attributedStringWithReplacement(NSAttributedString *origString, NSString *find, NSString *replace) {
	NSMutableAttributedString *newString = [origString mutableCopy];
	while ([newString.mutableString containsString:find]) {
        NSRange range = [newString.mutableString rangeOfString:find];
		NSMutableAttributedString *replaceString = [[NSMutableAttributedString alloc] initWithString:replace];
		[newString enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary<NSAttributedStringKey, id> *attrs, NSRange range, BOOL *stop) {
			[replaceString addAttributes:attrs range:NSMakeRange(0, replaceString.length)];
		}];
        [newString replaceCharactersInRange:range withAttributedString:replaceString];
    }
	return [newString copy];
}

// Global text views
%hook UILabel

- (void)setText:(NSString *)text {
	if (self.tag != 317) {
		for (NSString *find in strings) {
			text = stringWithReplacement(text, find, [strings objectForKey:find], NO);
		}
	}
	%orig(text);
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
	for (NSString *find in strings) {
		attributedText = attributedStringWithReplacement(attributedText, find, [strings objectForKey:find]);
	}
	%orig(attributedText);
}

%end

%hook UITextView

- (void)setText:(NSString *)text {
	for (NSString *find in strings) {
		text = stringWithReplacement(text, find, [strings objectForKey:find], NO);
	}
	%orig(text);
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
	for (NSString *find in strings) {
		attributedText = attributedStringWithReplacement(attributedText, find, [strings objectForKey:find]);
	}
	%orig(attributedText);
}

%end

%ctor {
	strings = @{
        @"Roaming danych": @"Rimming",
        @"Data Roaming": @"Rimming",
        @"Roaming": @"Rimming",
        @"roaming": @"rimming",
	};
}