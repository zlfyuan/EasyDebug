//
//  EDLocalizationSetting.swift
//  Pods
//
//  Created by zluof on 2023/4/4.
//  Copyright © 2023 zluof <https://github.com/zlfyuan/>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//


import Foundation

fileprivate var bundleByLanguageCode: [String: Bundle] = [:]

class EDLocalizationSetting: NSObject {

    fileprivate static let currentLanguageKey = "currentLanguage"
        
    enum Language: String {
        case Chinese = "zh-Hans"
        case English = "en"
        
        var code: String {
            return rawValue
        }
    }
    
    static func setCurrentLanguage(_ language: Language) {
        // 保存语言设置
        UserDefaults.standard.set(language.code, forKey: EDLocalizationSetting.currentLanguageKey)
        UserDefaults.standard.synchronize()
    }
    
    static func setSystemLanguage() {
        let systemLanguage: Language = {
            if let lang = Locale.preferredLanguages.first {
                return useCodeCheck(lang)
            } else {
                return .English
            }
        }()
        setCurrentLanguage(systemLanguage)
    }

    static func currentLanguage() -> Language {
        if let savedLanguageStr = UserDefaults.standard.object(forKey: EDLocalizationSetting.currentLanguageKey) as? String {
            return useCodeCheck(savedLanguageStr)
        } else {
            if let lang = Locale.preferredLanguages.first {
                return useCodeCheck(lang)
            } else {
                return .English
            }
        }
    }
    
    fileprivate static func useCodeCheck(_ code: String) -> Language {
        if code.hasPrefix("zh") {
            return .Chinese
        } else if code.contains("en") {
            return .English
        } else {
            return .English
        }
    }
}

extension EDLocalizationSetting.Language {
    var bundle: Bundle? {
        if let bundle = bundleByLanguageCode[code] {
            return bundle
        } else {
            if let path = EDCommon.easyDebugBundle.path(forResource: code, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                bundleByLanguageCode[code] = bundle
                return bundle
            } else {
                return nil
            }
        }
    }
}
