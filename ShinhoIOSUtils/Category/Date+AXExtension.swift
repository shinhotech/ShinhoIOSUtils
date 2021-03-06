//
//  Date+AXExtension.swift
//  ShinhoIOSUtils
//
//  Created by Lcm on 2020/9/23.
//

import UIKit
private let dateFormatter = DateFormatter()
/// yyyy.M.d
let dateFormat = "yyyy.M.d"
/// HH:mm
let timeFormat = "HH:mm"
/// yyyy.M.d HH:mm
let dateTimeFormat = "yyyy.M.d HH:mm"
/// yyyy.MM.dd HH:mm
let dateTimeFormat2 = "yyyy.MM.dd HH:mm"
/// yyyy.M
let yearMonthFormat = "yyyy.M"
/// yyyy-MM-dd
let dateFormat1 = "yyyy-MM-dd"


extension Date {
    var ts: Double {
        return self.timeIntervalSince1970 * 1000
    }
    
    var tsString: String {
        return "\(Int(ts))"
    }
    
    var dateString: String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    var timeString: String {
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: self)
    }
    
    var dateTimeString: String {
        dateFormatter.dateFormat = dateTimeFormat
        return dateFormatter.string(from: self)
    }
    
    var dateTimeString2: String {
        dateFormatter.dateFormat = dateTimeFormat2
        return dateFormatter.string(from: self)
    }
    
    var hour: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self)
        return components.hour!
    }
    
    var month: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self)
        return components.month!
    }
    
    var localDate: Date {
        let zone = NSTimeZone.local
        let interval = zone.secondsFromGMT(for: self)
        let date = addingTimeInterval(TimeInterval(interval))
        return date
    }
    
    /// 这一天的0时0分0秒的秒数
    var day2Second: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)?.timeIntervalSince1970.int ?? 0
    }
    /// 这一月的0日0时0分0秒的秒数
    var month2Second: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)?.timeIntervalSince1970.int ?? 0
    }
    
    /// 这个月的第一天
    var monthFirstDay: Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        if let first = calendar.date(from: components) {
            let zone = NSTimeZone.local
            let interval = zone.secondsFromGMT(for: first)
            return first.addingTimeInterval(TimeInterval(interval))
        }
        return self
    }
    
    /// 这个月的最后一天
    var monthLastDay: Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        components.day = -1
        
        if let last = calendar.date(byAdding: components, to: monthFirstDay) {
            let zone = NSTimeZone.local
            let interval = zone.secondsFromGMT(for: last)
            return last.addingTimeInterval(TimeInterval(interval))
        }
        return self
    }
    
    func same(with other: Date?) -> Bool {
        if let date = other {
            let calendar = Calendar.current
            let comp1 = calendar.dateComponents([.year, .month, .day], from: self)
            let comp2 = calendar.dateComponents([.year, .month, .day], from: date)
            return (comp1.day == comp2.day) &&
                (comp1.month == comp2.month) &&
                (comp1.year == comp2.year)
        } else {
            return false
        }
    }
    /// 根据输入的年月日生成日期对象
    ///
    /// :param year
    /// :param month
    /// :param day
    /// :return Date
    public static func from(year: Int, month: Int, day: Int, hour:Int = 5,min: Int = 30, sec:Int = 30) -> Foundation.Date? {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        c.hour = hour
        c.minute = min
        c.second = sec
        let IdentifierGregorian = Calendar.Identifier.gregorian
        let gregorianC = Calendar(identifier: IdentifierGregorian)
        return gregorianC.date(from: c)
    }
    
    /**
     返回根据历法所取到的值
     
     - parameter component: NSCalendarUnit 历法
     - returns: 根据历法所需要的值
     */
    
    public func getComponent (_ component : NSCalendar.Unit) -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(component, from: self)
        var com:Calendar.Component!
        switch component {
        case NSCalendar.Unit.year:
            com = .year
        case NSCalendar.Unit.month:
            com = .month
        case NSCalendar.Unit.weekday:
            com = .weekday
        case NSCalendar.Unit.weekOfMonth:
            com = .weekOfMonth
        case NSCalendar.Unit.day:
            com = .day
        case NSCalendar.Unit.hour:
            com = .hour
        case NSCalendar.Unit.minute:
            com = .minute
        case NSCalendar.Unit.second:
            com = .second
            
        default:
            assert(true)
        }
        return components.value(for: com)!
    }
    
    /**
     天
     */
    public var days : Int {
        get {
            return getComponent(.day)
        }
    }
    
    /// 这是周几
    public var week : String{
        get{
            if(self.weekday == 1){
                return "日"
            }
            if(self.weekday == 2){
                return "一"
            }
            if(self.weekday == 3){
                return "二"
            }
            if(self.weekday == 4){
                return "三"
            }
            if(self.weekday == 5){
                return "四"
            }
            if(self.weekday == 6){
                return "五"
            }
            if(self.weekday == 7){
                return "六"
            }
            return "未知星期"
        }
    }
    
    ///提前几天
    func beforeDate(_ befor:Int)->Foundation.Date{
        let time = self.timeIntervalSince1970
        let newDate = Foundation.Date(timeIntervalSince1970: time - Double(befor * 3600 * 24))
        return newDate
    }
    ///推迟几天
    func nextDate(_ befor:Int)->Foundation.Date{
        let time = self.timeIntervalSince1970
        let newDate = Foundation.Date(timeIntervalSince1970: time + Double(befor * 3600 * 24))
        return newDate
    }
    /// 获取阴历的日子
    ///
    /// - Returns: int
    func getLunarDayInfo()-> Int{
        let calender = Calendar(identifier: Calendar.Identifier.chinese)
        return calender.component(.day, from: self)
    }
    
    /**
     当月有几天
     */
    public func numOfDayFormMouth()->Int{
        let calendar = Calendar.current
        let range = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        
        return range.length
    }
}
