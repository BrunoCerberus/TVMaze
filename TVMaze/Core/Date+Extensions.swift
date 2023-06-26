//
//  Date+Extensions.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

extension Date {
    enum dateFormatStyle: String {
        case longDateTime = "dd/MM/yyyy 'às' HH:mm"
        case longDateTimeDetailed = "dd/MM/yyyy 'às' HH:mm:SS"
        case shortDate = "dd/MM/yyyy"
        case reversedStashedDate = "yyyy-MM-dd"
        case longDateTimeGMT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case longDateTimeGMTLoan = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
        case longDateTimeGMTQuickSale = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case longDateTimeGMTRewards = "yyyy-MM-dd'T'HH:mm:ss"
        case longDateTimeGMTServices = "yyyy-MM-dd HH:mm:ss.SSS"
        case longDateTimeGMTShellbox = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case fullDateWithTimeZone = "yyyy-MM-dd'T'HH:mm:ssZ"
        case shortDayMonthDate = "dd MMM"
        case dayMonthDate = "dd/MM"
        case longDateTimeDetailGMT = "yyyy-MM-dd HH:mm:SS"
        case monthYear = "MM/yy"
        case timeDate = "HH:mm"
        case longDateTimeBRT = "dd/MM/yyyy HH:mm:ss"
        case longDateDetail = "dd 'de' MMMM 'de' yyyy"
        case middleDateHour = "yyMMddHHmm"
        case yearDate = "yyyy"
        case shortMonthName = "MMM"
        case monthAndYearName = "MMMM yyyy"
        case month = "MMMM"
        case longDateTimeGMTPaymentLink = "yyyy-MM-dd'T'23:59:59ZZZZZ"
    }
    
    func toString(with format: dateFormatStyle) -> String {
        return toString(withFormat: format.rawValue)
    }
    
    func toString(withFormat: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    func isDateOver(_ years: Int) -> Bool {
        let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: self, to: Date())
        guard let age: Int = ageComponents.year else {
            return false
        }
        return age >= years
    }
}

extension TimeInterval {
    func toString() -> String {
        String(self)
    }
}

extension Date {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            return true
        }
        return false
    }
}

extension Date {
    func years(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
}
