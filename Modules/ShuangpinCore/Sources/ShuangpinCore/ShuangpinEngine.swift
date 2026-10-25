/// Pure Swift expansion of two-key Jyutping shuangpin codes into full Jyutping.
public enum ShuangpinEngine {

        private static let initialsByKey: [String: String] = [
                "b": "b",
                "c": "c",
                "d": "d",
                "f": "f",
                "g": "g",
                "h": "h",
                "i": "gw",
                "k": "k",
                "l": "l",
                "m": "m",
                "n": "n",
                "o": "",
                "p": "p",
                "s": "s",
                "t": "t",
                "u": "kw",
                "v": "ng",
                "w": "w",
                "y": "j",
                "z": "z"
        ]

        private static let finalsByKey: [String: [String]] = [
                ";": ["ik", "ing"],
                "a": ["aa"],
                "b": ["ou"],
                "c": ["aam", "aap"],
                "d": ["am", "ap"],
                "e": ["e"],
                "f": ["an", "at"],
                "g": ["ak", "ang", "eng"],
                "h": ["aak", "aang"],
                "i": ["i"],
                "j": ["aan", "aat"],
                "k": ["aau", "au"],
                "l": ["aai", "ai"],
                "m": ["im", "ip"],
                "n": ["in"],
                "o": ["o", "oi"],
                "p": ["eon", "un", "ung", "ut"],
                "q": ["iu"],
                "r": ["uk", "yun", "yut"],
                "s": ["ok", "on", "ong", "ot"],
                "t": ["ek", "it"],
                "u": ["u"],
                "v": ["ui", "yu"],
                "w": ["oe"],
                "x": ["oek", "oeng"],
                "y": ["eoi", "eot"],
                "z": ["ei"]
        ]

        private static let maximumExpansionCount = 512

        /// Expands the two-key input into all possible full Jyutping syllable strings.
        ///
        /// `;`, `'`, and `` ` `` are all accepted as the shuangpin `ing`/`ik` key.
        public static func fullJyutpingOptions(for input: String) -> [String] {
                let chunks = codeChunks(for: input)
                let optionSets: [[String]] = chunks.compactMap(options(for:))
                guard optionSets.count == chunks.count else { return [] }
                let expansionCount = optionSets.reduce(1, { $0 * $1.count })
                let limitedSets = expansionCount > maximumExpansionCount ? optionSets.map({ Array($0.prefix(1)) }) : optionSets
                return combine(limitedSets).map({ $0.joined() })
        }

        /// Expands the input one syllable at a time, returning each syllable's options.
        public static func syllableOptions(for input: String) -> [[String]] {
                return codeChunks(for: input).compactMap(options(for:))
        }

        private static func codeChunks(for input: String) -> [String] {
                let characters = input.lowercased().compactMap({ character -> Character? in
                        if character.isLetter {
                                return character
                        } else if character == ";" || character == "'" || character == "`" {
                                return Character(";")
                        } else {
                                return nil
                        }
                })
                return stride(from: 0, to: characters.count, by: 2).compactMap({ index -> String? in
                        let start = characters.index(characters.startIndex, offsetBy: index)
                        let end = characters.index(start, offsetBy: 2, limitedBy: characters.endIndex) ?? characters.endIndex
                        let chunk = String(characters[start..<end])
                        return chunk.count == 2 ? chunk : nil
                })
        }

        private static func options(for code: String) -> [String]? {
                if code == "om" {
                        return ["m"]
                }
                if code == "ov" {
                        return ["ng"]
                }
                guard code.count == 2 else { return nil }
                let characters = Array(code)
                let initialKey = String(characters[0])
                let finalKey = String(characters[1])
                guard let initial = initialsByKey[initialKey] else { return nil }
                guard let finals = finalsByKey[finalKey] else { return nil }
                return finals.map({ initial + $0 })
        }

        private static func combine(_ optionSets: [[String]]) -> [[String]] {
                guard let first = optionSets.first else { return [[]] }
                let rest = combine(Array(optionSets.dropFirst()))
                return first.flatMap({ syllable in
                        rest.map({ [syllable] + $0 })
                })
        }
}
