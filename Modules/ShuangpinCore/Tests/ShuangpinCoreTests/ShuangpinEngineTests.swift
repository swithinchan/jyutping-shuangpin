import Testing
@testable import ShuangpinCore

@Test func expandsSingleSyllable() {
        #expect(ShuangpinEngine.syllableOptions(for: "cx") == [["coek", "coeng"]])
        #expect(ShuangpinEngine.syllableOptions(for: "gs") == [["gok", "gon", "gong", "got"]])
        #expect(ShuangpinEngine.syllableOptions(for: "om") == [["m"]])
        #expect(ShuangpinEngine.syllableOptions(for: "ov") == [["ng"]])
}

@Test func acceptsAlternativeIngKeyCharacters() {
        #expect(ShuangpinEngine.syllableOptions(for: "z;") == [["zik", "zing"]])
        #expect(ShuangpinEngine.syllableOptions(for: "z'") == [["zik", "zing"]])
        #expect(ShuangpinEngine.syllableOptions(for: "z`") == [["zik", "zing"]])
}

@Test func expandsCompleteInputLine() {
        let options = ShuangpinEngine.fullJyutpingOptions(for: "cxsxz;zid;zpsiwlsyt;lk")
        #expect(!options.isEmpty)
        #expect(options.allSatisfy({ $0.count > 4 }))
}
